import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

SettingsRow {
    id: row
    property string selectedFamily
    stretch: true

    Controls.Button {
        id: button
        Layout.fillWidth: true
        text: row.selectedFamily || i18n("Select font")
        onClicked: popup.open()

        Controls.Popup {
            id: popup
            property var families: null
            y: button.height
            width: button.width
            padding: Kirigami.Units.smallSpacing
            onAboutToShow: {
                if (families === null)
                    families = Qt.fontFamilies().sort((a, b) => a.localeCompare(b))
                search.clear()
                list.positionViewAtBeginning()
            }
            onOpened: search.forceActiveFocus()

            contentItem: ColumnLayout {
                spacing: Kirigami.Units.smallSpacing

                Controls.TextField {
                    id: search
                    Layout.fillWidth: true
                    placeholderText: i18n("Search fonts")
                }

                ListView {
                    id: list
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(contentHeight, Kirigami.Units.gridUnit * 12)
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    model: {
                        const query = search.text.trim().toLocaleLowerCase()
                        const fonts = popup.families || []
                        return query ? fonts.filter(name => name.toLocaleLowerCase().includes(query)) : fonts
                    }
                    delegate: Controls.ItemDelegate {
                        required property string modelData
                        width: ListView.view.width
                        text: modelData
                        highlighted: modelData === row.selectedFamily
                        onClicked: {
                            row.selectedFamily = modelData
                            popup.close()
                        }
                    }
                }
            }
        }
    }

    Controls.Button {
        text: i18n("Reset")
        Accessible.name: i18n("Use system font family")
        enabled: row.selectedFamily !== ""
        onClicked: row.selectedFamily = ""
    }
}
