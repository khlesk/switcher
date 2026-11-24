import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

RowLayout {
    id: row
    default property alias fields: controls.data
    property bool stretch: false
    readonly property int indent: Kirigami.Units.smallSpacing

    Layout.fillWidth: stretch
    spacing: 0

    children: [
        RowLayout {
            id: controls
            Layout.fillWidth: row.stretch
            Layout.leftMargin: row.indent
            Layout.rightMargin: Kirigami.Units.largeSpacing + row.indent
            spacing: row.indent
        }
    ]
}
