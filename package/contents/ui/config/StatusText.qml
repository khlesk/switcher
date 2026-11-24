import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

SettingsForm {
    property alias cfg_showStatusText: showText.checked
    property alias cfg_statusFontFamily: family.selectedFamily
    property alias cfg_statusFontSize: size.value
    property alias cfg_statusUseCommand: useCommand.checked
    property alias cfg_statusCommand: commandField.text
    property alias cfg_statusInterval: interval.value

    SettingsRow {
        Controls.CheckBox {
            id: showText
            text: i18n("Show status text")
        }
    }

    SettingsRow {
        Controls.CheckBox {
            id: useCommand
            text: i18n("Run a command for status text")
        }
    }

    SettingsRow {
        Kirigami.FormData.label: i18n("Command:")
        stretch: true
        enabled: useCommand.checked

        Controls.TextField {
            id: commandField
            Layout.fillWidth: true
            placeholderText: i18n("bash ~/bin/status.sh")
        }

        EditScriptButton {
            command: commandField.text
        }
    }

    SettingsRow {
        Kirigami.FormData.label: i18n("Refresh interval (seconds):")

        Controls.SpinBox {
            id: interval
            enabled: useCommand.checked
            editable: true
            from: 1
            to: 86400
        }
    }

    Item {
        Kirigami.FormData.isSection: true
        implicitHeight: Kirigami.Units.gridUnit
    }

    SettingsRow {
        Kirigami.FormData.label: i18n("Font size (points):")

        Controls.SpinBox {
            id: size
            from: 0
            to: 96
            textFromValue: value => value === 0 ? i18n("System default") : String(value)
        }
    }

    FontPicker {
        id: family
        Kirigami.FormData.label: i18n("Font family:")
    }
}
