import QtCore
import QtQuick.Controls as Controls
import org.kde.plasma.plasma5support as P5Support

Controls.Button {
    required property string command
    readonly property string scriptUrl: {
        const word = command.trim().replace(/^(?:(?:\/usr)?\/bin\/)?(?:ba)?sh\s+/, "")
        let path
        if (/^'[^']*(?:'\\''[^']*)*'$/.test(word)) {
            // Browse uses shell single quotes, including for filenames with apostrophes.
            path = word.slice(1, -1).replace(/'\\''/g, "'")
        } else if (/^"(?:\$HOME\/)?(?:[^"\\$`]|\\["\\$`])*"$/.test(word)) {
            path = word.slice(1, -1).replace(/^\$HOME\//, homePath + "/").replace(/\\(["\\$`])/g, "$1")
        } else if (/^(?:\/|~\/|\$HOME\/)[^\s'"\\$`;&|<>()*?\[\]{}]*$/.test(word)) {
            path = word.replace(/^(?:~|\$HOME)\//, homePath + "/")
        } else {
            return ""
        }
        if (!path.startsWith("/") || path.endsWith("/")) return ""
        return "file://" + path.split("/").map(encodeURIComponent).join("/")
    }
    readonly property string homePath: decodeURIComponent(StandardPaths.writableLocation(StandardPaths.HomeLocation).toString().slice(7))

    icon.name: "document-edit"
    text: i18n("Edit")
    enabled: scriptUrl !== ""
    onClicked: {
        const quotedUrl = "'" + scriptUrl.replace(/'/g, "'\\''") + "'"
        editor.connectSource("kioclient exec " + quotedUrl + " text/plain")
    }

    P5Support.DataSource {
        id: editor
        engine: "executable"
        onNewData: function(source, data) {
            if (data["exit code"] !== undefined) disconnectSource(source)
        }
    }
}
