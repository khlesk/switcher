import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

SettingsForm {
    property alias cfg_checkingText: checkingField.text
    property alias cfg_stoppedText: stoppedField.text
    property alias cfg_startingText: startingField.text
    property alias cfg_connectingText: connectingField.text
    property alias cfg_runningText: runningField.text
    property alias cfg_connectedText: connectedField.text
    property alias cfg_stoppingText: stoppingField.text
    property alias cfg_errorText: errorField.text

    SettingsRow {
        Kirigami.FormData.label: i18n("Checking:")
        stretch: true

        Controls.TextField {
            id: checkingField
            Layout.fillWidth: true
            placeholderText: i18n("Checking…")
        }
    }

    SettingsRow {
        Kirigami.FormData.label: i18n("Stopped:")
        stretch: true

        Controls.TextField {
            id: stoppedField
            Layout.fillWidth: true
            placeholderText: i18n("Stopped")
        }
    }

    SettingsRow {
        Kirigami.FormData.label: i18n("Starting:")
        stretch: true

        Controls.TextField {
            id: startingField
            Layout.fillWidth: true
            placeholderText: i18n("Starting…")
        }
    }

    SettingsRow {
        Kirigami.FormData.label: i18n("Connecting:")
        stretch: true

        Controls.TextField {
            id: connectingField
            Layout.fillWidth: true
            placeholderText: i18n("Connecting…")
        }
    }

    SettingsRow {
        Kirigami.FormData.label: i18n("Running:")
        stretch: true

        Controls.TextField {
            id: runningField
            Layout.fillWidth: true
            placeholderText: i18n("Running")
        }
    }

    SettingsRow {
        Kirigami.FormData.label: i18n("Connected:")
        stretch: true

        Controls.TextField {
            id: connectedField
            Layout.fillWidth: true
            placeholderText: i18n("Connected")
        }
    }

    SettingsRow {
        Kirigami.FormData.label: i18n("Stopping:")
        stretch: true

        Controls.TextField {
            id: stoppingField
            Layout.fillWidth: true
            placeholderText: i18n("Stopping…")
        }
    }

    SettingsRow {
        Kirigami.FormData.label: i18n("Error:")
        stretch: true

        Controls.TextField {
            id: errorField
            Layout.fillWidth: true
            placeholderText: i18n("Error")
        }
    }
}
