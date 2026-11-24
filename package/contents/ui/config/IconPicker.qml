import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import ".."

SettingsRow {
    id: row
    required property string stateKey
    required property string theme
    property string fileUrl
    readonly property string displayName: fileUrl ? decodeURIComponent(fileUrl.split("/").pop()) : i18n("Choose SVG…")

    StateIcon {
        theme: row.theme
        stateKey: row.stateKey
        overrideUrl: row.fileUrl
        Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
        Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
    }

    Controls.Button {
        Layout.leftMargin: Kirigami.Units.largeSpacing
        text: row.displayName
        Layout.preferredWidth: Kirigami.Units.gridUnit * 8
        Layout.maximumWidth: Kirigami.Units.gridUnit * 8
        Accessible.name: i18n("Choose icon for %1", row.Kirigami.FormData.label)
        onClicked: dialog.open()
        Controls.ToolTip.text: row.fileUrl
        Controls.ToolTip.visible: hovered && row.fileUrl !== ""
    }

    Controls.ToolButton {
        icon.name: "edit-undo"
        text: i18n("Restore bundled icon")
        display: Controls.AbstractButton.IconOnly
        visible: row.fileUrl !== ""
        onClicked: row.fileUrl = ""
        Controls.ToolTip.text: text
        Controls.ToolTip.visible: hovered
    }

    FileDialog {
        id: dialog
        title: i18n("Choose a state icon")
        nameFilters: [i18n("SVG images (*.svg *.svgz)")]
        onAccepted: row.fileUrl = selectedFile.toString()
    }
}
