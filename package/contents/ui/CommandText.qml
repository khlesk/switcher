import QtQuick
import "../code/TerminalText.js" as TerminalText
import org.kde.plasma.plasma5support as P5Support

Item {
    id: runner
    required property string command
    required property int refreshSeconds
    property string output: ""
    property string activeSource: ""
    property bool refreshPending: false

    function schedule(delay) {
        timer.interval = delay
        timer.restart()
    }

    function refreshAfterStateChange() {
        if (command) {
            refreshPending = false
            schedule(250)
        }
    }

    function resetCommand() {
        timer.stop()
        if (activeSource) executor.disconnectSource(activeSource)
        activeSource = ""
        output = ""
        refreshPending = false
        if (command) schedule(0)
    }

    Component.onCompleted: resetCommand()
    onCommandChanged: Qt.callLater(resetCommand)
    onRefreshSecondsChanged: {
        if (timer.running && timer.interval > 250)
            schedule(Math.max(1, refreshSeconds) * 1000)
    }

    Timer {
        id: timer
        onTriggered: {
            if (!runner.command) return
            if (runner.activeSource) {
                runner.refreshPending = true
                return
            }
            runner.activeSource = runner.command
            executor.connectSource(runner.activeSource)
        }
    }

    P5Support.DataSource {
        id: executor
        engine: "executable"
        onNewData: function(source, data) {
            if (source !== runner.activeSource || data["exit code"] === undefined) return
            disconnectSource(source)
            runner.activeSource = ""
            if (source !== runner.command) return
            runner.output = TerminalText.plainText(data.stdout) || TerminalText.plainText(data.stderr)
            if (!runner.output && data["exit code"] !== 0)
                runner.output = i18n("Command failed (exit %1).", data["exit code"])
            if (!timer.running)
                runner.schedule(runner.refreshPending ? 0 : Math.max(1, runner.refreshSeconds) * 1000)
            runner.refreshPending = false
        }
    }
}
