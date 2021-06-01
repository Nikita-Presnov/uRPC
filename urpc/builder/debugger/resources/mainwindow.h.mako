<%
    from urpc import ast
    from urpc.util.cconv import ascii_to_hex, get_msg_len, type_to_cstr
%>\
#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QGroupBox>
#include <QListWidget>

#include <limits>
#include <stdint.h>

#include "iopanel.h"

#include "intarroutput.h"
#include "intarrinput.h"

#include "intinput.h"
#include "intoutput.h"

#include "floatinput.h"
#include "floatoutput.h"

#include "floatarrinput.h"
#include "floatarroutput.h"

#include "container.h"

#include "iopanel.h"

#include "${library_header_file(protocol)}.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

    QListWidget *log;

    Container *MainContainer;

    void AddIOPanel(iopanel* Panel);

    void logAdd(QString str);
    void logClear();

    QLineEdit *comedit;

    device_t device;

    /* iopanels for commands
     * THIS CODE IS AUTOGENERATED
     */

    <%def name = "create_input_widget_head(cmd,arg)">\
        % if isinstance(arg.type_, ast.ArrayType):
            %if isinstance(arg.type_.type_, ast.FloatType):
    FloatArrInput* ${cmd.name}${arg.name}inputwidget;
            %else:
    IntArrInput* ${cmd.name}${arg.name}inputwidget;
            %endif
        % else:  ##### (it is not array)
            % if isinstance(arg.type_, ast.FloatType):
    FloatInput* ${cmd.name}${arg.name}inputwidget;
            % else:
    IntInput* ${cmd.name}${arg.name}inputwidget;
            %endif
        % endif
    </%def>

    <%def name = "create_output_widget_head(cmd,arg)">
        % if isinstance(arg.type_, ast.ArrayType):
            %if isinstance(arg.type_.type_, ast.FloatType):
    FloatArrOutput* ${cmd.name}${arg.name}outputwidget;
            %else:
    IntArrOutput* ${cmd.name}${arg.name}outputwidget;
            %endif
        % else:  ##### (it is not array)
            % if isinstance(arg.type_, ast.FloatType):
    FloatOutput* ${cmd.name}${arg.name}outputwidget;
            % else:
    IntOutput* ${cmd.name}${arg.name}outputwidget;
            %endif
        % endif
    </%def>


    % for cmd in protocol.commands:
    // command ${cmd.name}
    iopanel* ${cmd.name}iop;

    // req arguments
        % for arg in cmd.request.args:
    // argument ${arg.name} type ${type_to_cstr(arg.type_)}
    ${create_input_widget_head(cmd,arg)}
        % endfor
    // resp arguments
        % for arg in cmd.response.args:
    // argument ${arg.name} type ${type_to_cstr(arg.type_)}
    ${create_output_widget_head(cmd,arg)}
        % endfor

    % endfor



public slots:
    void connectButton();
    void dconnectButton();

    void SearchSlot(QString str);

    void GetProfileSlot();
    void SetProfileSlot();

    /* slots for buttons
     * THIS CODE IS AUTOGENERATED
     */

    % for cmd in protocol.commands:
    void ${cmd.name}PressSlot(bool);

        % if view.is_setter(cmd):
    void ${cmd.name}CallGetterPressSlot(bool);
        % endif
    % endfor

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
