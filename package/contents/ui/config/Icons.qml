import QtQuick
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

SettingsForm {
    id: form
    property string cfg_iconTheme: "default"
    property string cfg_iconThemeDefault
    property alias cfg_stoppedIcon: stopped.fileUrl
    property alias cfg_startingIcon: starting.fileUrl
    property alias cfg_activeIcon: active.fileUrl
    property alias cfg_stoppingIcon: stopping.fileUrl
    property alias cfg_errorIcon: errorIcon.fileUrl

    SettingsRow {
        Kirigami.FormData.label: i18n("Theme:")

        Controls.ComboBox {
            Accessible.name: i18n("Icon theme")
            textRole: "label"
            valueRole: "key"
            model: [
                { key: "default", label: i18n("Default") },
                { key: "slider", label: i18n("Pocket switch") },
                { key: "filament", label: i18n("Filament") },
                { key: "lunar", label: i18n("Lunar phases") },
                { key: "cassette", label: i18n("Play controls") }
            ]
            currentIndex: model.findIndex(item => item.key === form.cfg_iconTheme)
            onActivated: form.cfg_iconTheme = currentValue
        }
    }

    Item {
        Kirigami.FormData.isSection: true
        implicitHeight: Kirigami.Units.largeSpacing
    }

    IconPicker {
        Kirigami.FormData.label: i18n("Stopped:")
        id: stopped
        theme: form.cfg_iconTheme
        stateKey: "stopped"
    }

    IconPicker {
        Kirigami.FormData.label: i18n("Starting:")
        id: starting
        theme: form.cfg_iconTheme
        stateKey: "starting"
    }

    IconPicker {
        Kirigami.FormData.label: i18n("Active:")
        id: active
        theme: form.cfg_iconTheme
        stateKey: "active"
    }

    IconPicker {
        Kirigami.FormData.label: i18n("Stopping:")
        id: stopping
        theme: form.cfg_iconTheme
        stateKey: "stopping"
    }

    IconPicker {
        Kirigami.FormData.label: i18n("Error:")
        id: errorIcon
        theme: form.cfg_iconTheme
        stateKey: "error"
    }
}
