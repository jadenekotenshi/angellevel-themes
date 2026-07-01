import QtQuick 2.0

Rectangle {
    id: root
    width: 1024
    height: 768
    color: "#66788c"

    property int sessionIndex: 0
    property string sessionName: "Default"

    // theme.conf value or fallback
    function cfg(k, d) {
        return (typeof config !== "undefined" && config[k] && ("" + config[k]).length) ? config[k] : d
    }

    gradient: Gradient {
        GradientStop { position: 0.0; color: root.cfg("backgroundTop", "#93a6ba") }
        GradientStop { position: 1.0; color: root.cfg("backgroundBottom", "#5f7186") }
    }

    // optional wallpaper
    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: root.cfg("background", "")
        visible: source != ""
    }

    // --- clock (top-right) ---
    Text {
        id: clock
        anchors.right: parent.right; anchors.top: parent.top; anchors.margins: 26
        color: "#ffffff"; font.family: "Helvetica"; font.pixelSize: 17; font.bold: true
        style: Text.Raised; styleColor: "#40000000"
    }
    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "dddd  MMMM d      h:mm AP")
    }

    // --- hard drop shadow behind the login panel ---
    Rectangle {
        x: panel.x + 6; y: panel.y + 6; z: -1
        width: panel.width; height: panel.height; color: "#33000000"
    }

    // --- login panel ---
    Panel {
        id: panel
        width: 404
        height: 58 + body.implicitHeight
        anchors.centerIn: parent
        base: root.cfg("panelColor", "#b0b0b0")
        raised: true

        // title bar
        Rectangle {
            id: titleBar
            x: 2; y: 2; width: parent.width - 4; height: 26
            color: root.cfg("titleColor", "#6f8dbd")
            Rectangle { anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: 1; color: "#ffffff"; opacity: 0.45 }
            Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: 1; color: "#1a1a1a"; opacity: 0.35 }
            Text {
                anchors.centerIn: parent
                text: (typeof sddm !== "undefined" && sddm.hostName) ? sddm.hostName : "Log In"
                color: "#ffffff"; font.family: "Helvetica"; font.pixelSize: 13; font.bold: true
            }
        }

        Column {
            id: body
            anchors.top: titleBar.bottom; anchors.topMargin: 14
            anchors.left: parent.left; anchors.right: parent.right
            anchors.leftMargin: 16; anchors.rightMargin: 16
            spacing: 12

            // logo + welcome
            Row {
                spacing: 12
                Image { source: "assets/logo.svg"; width: 44; height: 44; sourceSize.width: 44; sourceSize.height: 44 }
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    Text { text: "Welcome to"; color: "#3a3a3a"; font.family: "Helvetica"; font.pixelSize: 12 }
                    Text {
                        text: (typeof sddm !== "undefined" && sddm.hostName) ? sddm.hostName : "SquirrelLevel"
                        color: "#1a1a1a"; font.family: "Helvetica"; font.pixelSize: 19; font.bold: true
                    }
                }
            }

            // Name
            Column {
                spacing: 3; width: parent.width
                Text { text: "Name:"; color: "#1a1a1a"; font.family: "Helvetica"; font.pixelSize: 12; font.bold: true }
                NeXTField {
                    id: userField
                    width: parent.width
                    placeholder: "username"
                    text: (typeof userModel !== "undefined" && userModel.lastUser) ? userModel.lastUser : ""
                    onAccepted: passField.field.forceActiveFocus()
                }
            }

            // Password
            Column {
                spacing: 3; width: parent.width
                Text { text: "Password:"; color: "#1a1a1a"; font.family: "Helvetica"; font.pixelSize: 12; font.bold: true }
                NeXTField {
                    id: passField
                    width: parent.width
                    placeholder: "password"
                    echoMode: TextInput.Password
                    onAccepted: root.doLogin()
                }
            }

            // error message
            Text {
                id: err
                width: parent.width
                text: ""; visible: text != ""
                color: "#a8241c"; font.family: "Helvetica"; font.pixelSize: 12; wrapMode: Text.WordWrap
            }

            // session selector + login button
            Item {
                width: parent.width; height: 30
                NeXTButton {
                    id: sessionBtn
                    anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                    width: 190; height: 28
                    text: "▴  " + root.sessionName
                    onClicked: {
                        var pt = sessionBtn.mapToItem(root, 0, 0)
                        sessionPopup.x = pt.x
                        sessionPopup.y = pt.y - sessionPopup.height - 3
                        sessionPopup.visible = !sessionPopup.visible
                    }
                }
                NeXTButton {
                    anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                    width: 118; height: 28
                    text: "Log In"
                    onClicked: root.doLogin()
                }
            }
        }
    }

    // --- session popup (child of root so it floats above the panel) ---
    Panel {
        id: sessionPopup
        parent: root
        visible: false
        raised: true; base: "#ffffff"
        width: 200
        height: sessCol.height + 6
        z: 10
        Column {
            id: sessCol
            anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
            anchors.margins: 3
            Repeater {
                model: (typeof sessionModel !== "undefined") ? sessionModel : 0
                delegate: Rectangle {
                    width: sessCol.width; height: 24
                    color: sma.containsMouse ? "#6f8dbd" : "#ffffff"
                    Text {
                        anchors.verticalCenter: parent.verticalCenter; x: 7
                        text: model.name
                        color: sma.containsMouse ? "#ffffff" : "#1a1a1a"
                        font.family: "Helvetica"; font.pixelSize: 13
                    }
                    MouseArea {
                        id: sma; anchors.fill: parent; hoverEnabled: true
                        onClicked: { root.sessionIndex = index; root.sessionName = model.name; sessionPopup.visible = false }
                    }
                    Component.onCompleted: if (index === root.sessionIndex) root.sessionName = model.name
                }
            }
        }
    }

    // --- power buttons (bottom-right) ---
    Row {
        anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 26
        spacing: 10
        NeXTButton {
            width: 92; height: 28; text: "Sleep"; textColor: "#33507e"
            visible: (typeof sddm !== "undefined") ? sddm.canSuspend : true
            onClicked: if (typeof sddm !== "undefined") sddm.suspend()
        }
        NeXTButton {
            width: 100; height: 28; text: "Restart"; textColor: "#8a5a15"
            visible: (typeof sddm !== "undefined") ? sddm.canReboot : true
            onClicked: if (typeof sddm !== "undefined") sddm.reboot()
        }
        NeXTButton {
            width: 116; height: 28; text: "Shut Down"; textColor: "#8f2218"
            visible: (typeof sddm !== "undefined") ? sddm.canPowerOff : true
            onClicked: if (typeof sddm !== "undefined") sddm.powerOff()
        }
    }

    // --- logic ---
    function doLogin() {
        err.text = ""
        if (typeof sddm !== "undefined")
            sddm.login(userField.text, passField.text, Math.max(0, root.sessionIndex))
    }

    Connections {
        target: (typeof sddm !== "undefined") ? sddm : null
        onLoginFailed: {
            err.text = "Authentication failed — please try again."
            passField.text = ""
            passField.field.forceActiveFocus()
        }
        onLoginSucceeded: err.text = ""
    }

    Component.onCompleted: {
        if (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0)
            root.sessionIndex = sessionModel.lastIndex
        if (userField.text.length > 0)
            passField.field.forceActiveFocus()
        else
            userField.field.forceActiveFocus()
    }
}
