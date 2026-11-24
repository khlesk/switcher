import QtQuick
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: form
    Binding {
        target: form
        property: "implicitWidth"
        value: form.width
        when: form.width > 0
        restoreMode: Binding.RestoreBinding
    }

    Controls.Label {
        Kirigami.FormData.isSection: true
        text: ""
    }
}
