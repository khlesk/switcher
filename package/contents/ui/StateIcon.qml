import QtQuick

Item {
    id: icon
    required property string stateKey
    property string theme: "default"
    property string overrideUrl
    implicitWidth: 32
    implicitHeight: 32

    Image {
        anchors.fill: parent
        visible: replacement.status !== Image.Ready
        source: "../images/states/" + (icon.theme === "default" ? "" : icon.theme + "/") + icon.stateKey + ".svg"
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(128, 128)
    }

    Image {
        id: replacement
        anchors.fill: parent
        source: icon.overrideUrl
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(128, 128)
    }
}
