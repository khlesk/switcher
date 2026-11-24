import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

SettingsForm {
    property alias cfg_tooltipUseCommand: useCommand.checked
    property alias cfg_tooltipCommand: commandField.text
    property alias cfg_tooltipInterval: interval.value
    property alias cfg_tooltipShowStatus: showStatus.checked
    property alias cfg_tooltipText: tooltipField.text

    SettingsRow {
        Controls.CheckBox {
            id: useCommand
            text: i18n("Run a command for tooltip text")
        }
    }

    SettingsRow {
        Kirigami.FormData.label: i18n("Command:")
        stretch: true
        enabled: useCommand.checked

        Controls.TextField {
            id: commandField
            Layout.fillWidth: true
            placeholderText: i18n("bash ~/bin/tooltip.sh")
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

    SettingsRow {
        Kirigami.FormData.label: i18n("Default text:")
        stretch: true

        Controls.TextField {
            id: tooltipField
            Layout.fillWidth: true
            placeholderText: i18n("Show errors and the next action")
        }
    }

    SettingsRow {
        Controls.CheckBox {
            id: showStatus
            text: i18n("Show status after tooltip text")
        }
    }
}
