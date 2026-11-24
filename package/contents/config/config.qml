import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "settings-configure"
        source: "config/General.qml"
    }

    ConfigCategory {
        name: i18n("Status text")
        icon: "preferences-desktop-font"
        source: "config/StatusText.qml"
    }

    ConfigCategory {
        name: i18n("State labels")
        icon: "edit-rename"
        source: "config/StateLabels.qml"
    }

    ConfigCategory {
        name: i18n("Tooltip")
        icon: "dialog-information"
        source: "config/Tooltip.qml"
    }

    ConfigCategory {
        name: i18n("State icons")
        icon: "preferences-desktop-icons"
        source: "config/Icons.qml"
    }
}
