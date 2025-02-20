/*
 * Each file must start with this include.
 * File containes global settings.
 */
#include "settings.h"

/*
 * Main includes here.
 */
#include "stm32f1xx.h"
#include "usb.h"

/*
 * Other includes here.
 */
#include "stm32f1xx_ll_bus.h"
#include "stm32f1xx_ll_gpio.h"
#include "stm32f1xx_ll_irq.h"
#include "usbd_core.h"
#include "usbd_desc.h"
#include "usbd_cdc.h"
#include "usbd_cdc_if.h"
#include "flowparser.h"   // Upper level interface
#include "iobuffer.h"

// FreeRTOS files
#include "FreeRTOS.h"
#include "timers.h"

#define USB_PORT      GPIOA
#define USB_PORT_CLK  LL_APB2_GRP1_PERIPH_GPIOA
#define USB_DISC_PIN  LL_GPIO_PIN_12


TimerHandle_t CleanRxBufferTimerHandle;
/*
 * USB Device Core handle declaration.
 */
USBD_HandleTypeDef hUsbDeviceFS;

static io_buffer_t RxBuffer;
static io_buffer_t TxBuffer;

/*
 * This buffers hold incoming
 * and outcoming flows.
 */
static uint8_t USBRxBuffer[_PACKET_LENGTH];
static uint8_t USBTxBuffer[_PACKET_LENGTH];

static void USB_IntHandler(void);
static void RxBufferCleaner(TimerHandle_t xTimer);
static void DataTransmitting(void);

INIT_STATE_VAR(USB);

/*
 * Initialize USB.
 */
void USB_Init(void)
{
  INIT_START(USB);

  // Initialize and start timer for Rx buffer cleaning
  CleanRxBufferTimerHandle = xTimerCreate("Clean Rx buffer timer",
                                          pdMS_TO_TICKS(_PROTOCOL_DELAY),
                                          pdFALSE,
                                          ( void * ) 0,
                                          RxBufferCleaner);

  if (CleanRxBufferTimerHandle == NULL)
  {
    #ifdef DEBUG
    printf ("The timer was not created.\n");
    while (1); // Infinite loop
    #endif
  }

  if (xTimerStart(CleanRxBufferTimerHandle, 0) != pdPASS)
  {
    #ifdef DEBUG
    printf ("The timer was not started.\n");
    while (1); // Infinite loop
    #endif
  }

  LL_APB1_GRP1_EnableClock(LL_APB1_GRP1_PERIPH_USB);
  LL_APB2_GRP1_EnableClock(USB_PORT_CLK);

  /*
   * Init Device Library, add supported class and start the library.
   */
  USBD_Init(&hUsbDeviceFS, &FS_Desc, DEVICE_FS);

  USBD_RegisterClass(&hUsbDeviceFS, &USBD_CDC);
  USBD_CDC_RegisterInterface(&hUsbDeviceFS, &USBD_Interface_fops_FS);

  LL_IRQ_Init(USB_LP_CAN1_RX0_IRQn, USB_IntHandler);

  /*
   * Interrupts in core.
   */
  NVIC_ClearPendingIRQ(USB_LP_CAN1_RX0_IRQn);
  NVIC_EnableIRQ(USB_LP_CAN1_RX0_IRQn);

  LL_GPIO_InitTypeDef GPIO_InitStructure;

  /*
   * The initial data for disconnect pin.
   */
  GPIO_InitStructure.Pin        = USB_DISC_PIN;
  GPIO_InitStructure.Mode       = LL_GPIO_MODE_OUTPUT;
  GPIO_InitStructure.Speed      = LL_GPIO_SPEED_FREQ_HIGH;
  GPIO_InitStructure.OutputType = LL_GPIO_OUTPUT_PUSHPULL;
  GPIO_InitStructure.Pull       = LL_GPIO_PULL_DOWN;  // Low level. It does immediately active state for connect

  LL_GPIO_Init(USB_PORT, &GPIO_InitStructure);

  USBD_Start(&hUsbDeviceFS);

  INIT_END(USB);
}

int8_t CDC_Init_FS(void)
{
  /*
   * Set application buffers.
   */
  USBD_CDC_SetTxBuffer(&hUsbDeviceFS, USBTxBuffer, _PACKET_LENGTH);
  USBD_CDC_SetRxBuffer(&hUsbDeviceFS, USBRxBuffer);

  return USBD_OK;
}

int8_t CDC_Receive_FS(uint8_t *Buf, uint32_t *Len)
{
  IOBuffer_PutBuf(&RxBuffer, Buf, *Len);  // First put data into buffer

  if (xTimerReset(CleanRxBufferTimerHandle, 0) != pdPASS)
  {
    #ifdef DEBUG
    printf ("The timer was not started.\n");
    while (1); // Infinite loop
    #endif
  }

  /*
   * Process received data and check whether there was a response continuosly.
   * There may be two or more commands in one transmission. We must handle
   * it anyways.
   */
  while (FlowParser_Process(&RxBuffer, &TxBuffer))
  {
    DataTransmitting();   // While there is a response, put data from TxBuffer to Tx FIFO until Tx empty or FIFO full
  }

  USBD_CDC_ReceivePacket(&hUsbDeviceFS);

  return USBD_OK;
}

static void USB_IntHandler(void)
{
  HAL_PCD_IRQHandler(&hpcd_USB_FS);
}

/*
 * This callback function is an input buffer cleaner.
 * Every new byte moves the callback away.
 * No new bytes results in input buffer cleaning.
 * It is required for devices left in non synchronized state.
 * There is no way to synchronize such device during.
 * device discovery unless its input buffer is clean.
 */
static void RxBufferCleaner(TimerHandle_t xTimer)
{
  IOBuffer_ReInit(&RxBuffer);
}

static void DataTransmitting(void)
{
  uint16_t Size = IOBuffer_Size(&TxBuffer);

  IOBuffer_GetBuf(&TxBuffer, USBTxBuffer, Size);

  CDC_Transmit_FS(USBTxBuffer, Size);
}
