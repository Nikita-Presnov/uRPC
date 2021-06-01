from os.path import abspath, dirname, join
from urpc.builder.firmware.common import build_firmware


def build_STM32F429ZI(project, output):
    build_firmware(project, output, join(abspath(dirname(__file__)), "resources"))
