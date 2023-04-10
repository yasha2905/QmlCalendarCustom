import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2


ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    property var tempDate: new Date()
    Button {
        id: button
        // lets set the current datew when the application is starting
        text: Qt.formatDate(tempDate, "dd.MM.yyyy");
        anchors.centerIn: parent // make in centered
        onClicked: dialogCalendar.show(tempDate)
    }
    Dialog{
        id: dialogCalendar
        // set the size for dialog window
        width: 250
        height: 300

        // lets create the content for dialog window
        contentItem: Rectangle{
            id: dialogRect
            color: "#f7f7f7"

            // lets create the custom calendar
            Calendar{
                id: calendar
                // put it to up
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: row.top
                style: CalendarStyle {
                    navigationBar: Rectangle{
                        height: 48
                        color: "#f7f7f7"

                        //horizontal separator between navigationBar and date figures
                        Rectangle {
                            // rectungle with 2 buttons and label
                            color: "#d7d7d7"
                            height: 1
                            width: parent.width
                            anchors.bottom: parent.bottom
                        }
                        // button to scroll months back
                        Button {
                            id: previousMonth
                            width: parent.height - 8
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 8

                            // call function to get month back
                            onClicked: control.showPreviousMonth()

                            // make button styled
                            style: ButtonStyle{
                                background: Rectangle {
                                    color: "#f7f7f7"
                                    Image {
                                        source: control.pressed ? "left_arrow_disable.png" : "left_arrow.png"
                                        width: parent.height - 8
                                        height: width
                                    }
                                }
                            }
                        }
                        // put styled Label

                        Label {
                            id: dateText
                            // take data from Calendar title it will not be seen but will be reolaced with this label
                            text: styleData.title
                            color:  "#34aadc"
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: previousMonth.right
                            anchors.leftMargin: 2
                            anchors.right: nextMonth.left
                            anchors.rightMargin: 2
                        }

                        // button to scroll months forward
                        Button {
                            id: nextMonth
                            width: parent.height - 8
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            // call function to get month forward
                            onClicked: control.showNextMonth()

                            style: ButtonStyle {
                                background: Rectangle {
                                    color: "#f7f7f7"
                                    Image {
                                        source: control.pressed ? "right_arrow_disable.png" : "right_arrow.png"
                                        width: parent.height - 8
                                        height: width
                                    }
                                }
                            }
                        }
                    }

                    // style for squares with date month's
                    dayDelegate: Rectangle {
                        anchors.fill: parent
                        anchors.margins: styleData.selected ? -1 : 0
                        // define color (selected or not)
                        color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"
                        // define read only colors
                        readonly property color sameMonthDateTextColor: "#444"
                        readonly property color selectedDateColor: "#34aadc"
                        readonly property color selectedDateTextColor: "white"
                        readonly property color differentMonthDateTextColor: "#bbb"
                        readonly property color invalidDateColor: "#dddddd"

                        // put  Label to show figures
                        Label {
                            id: dayDelegateText
                            text: styleData.date.getDate() // put figure into current square
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 10
                            // set color
                            color: {
                                var theColor = invalidDateColor; // set unvalid color for text
                                if (styleData.valid) {
                                    // set color for text depends on current month or not
                                    theColor = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                    if (styleData.selected)
                                        // repaint if selected date in calendar
                                        theColor = selectedDateTextColor;
                                }
                                theColor;
                            }
                        }
                    }
                }
            }

        // lets do the panel with buttons
        Row {
            id: row
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            // Button to close the dialog
            Button {
                id: dialogButtonCalCancel
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width / 2 - 1

                style: ButtonStyle {
                    background: Rectangle {
                        color: control.pressed ? "#d7d7d7" : "#f7f7f7"
                        border.width: 0
                    }

                    label: Text {
                        text: qsTr("Cancel")
                        font.pixelSize: 14
                        color: "#34aadc"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                // if pushed, just close the dialog
                onClicked: dialogCalendar.close()
            }
            // vertical separator between buttons
            Rectangle {
                id: dividerVertical
                width: 2
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                color: "#d7d7d7"
            }
            // button to confirm selected date
            Button {
                id: dialogButtonCalOk
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width / 2 - 1

                style: ButtonStyle {
                    background: Rectangle {
                        color: control.pressed ? "#d7d7d7" : "#f7f7f7"
                        border.width: 0
                    }
                    label: Text {
                        text: qsTr("Ok")
                        font.pixelSize: 14
                        color: "#34aadc"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                //by click save selected date to temp variable and put it on the button in the main window
                // and close the dialog
                onClicked: {
                    tempDate = calendar.selectedDate
                    button.text = Qt.formatDate(tempDate, "dd.MM.yyyy");
                    dialogCalendar.close();
                }
            }
        }
    }

    // function to set date from button otherwise will be opened current date
    function show(x){
        calendar.selectedDate = x
        dialogCalendar.open()
    }
    }
}

