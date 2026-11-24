import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

SettingsForm {
    property alias cfg_launchCommand: commandField.text
    property string cfg_launchCommandDefault

    SettingsRow {
        Kirigami.FormData.label: i18n("Command:")
        stretch: true

        Controls.TextField {
            id: commandField
            Layout.fillWidth: true
            Layout.preferredWidth: Kirigami.Units.gridUnit * 12
            placeholderText: i18n("bash ~/bin/my-script.sh")
            Accessible.name: i18n("Command")
        }

        Controls.Button {
            icon.name: "document-open"
            text: i18n("Browse…")
            onClicked: fileDialog.open()
        }

        EditScriptButton {
            command: commandField.text
        }
    }

    FileDialog {
        id: fileDialog
        title: i18n("Choose a script or executable")
        onAccepted: {
            const path = decodeURIComponent(selectedFile.toString().slice(7))
            const interpreter = /\.(sh|bash)$/i.test(path) ? "bash " : ""
            commandField.text = interpreter + "'" + path.replace(/'/g, "'\\''") + "'"
            commandField.forceActiveFocus()
        }
    }
}
