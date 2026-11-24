pragma ComponentBehavior: Bound

import QtQuick
import "../code/TerminalText.js" as TerminalText
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root

    property string serviceState: "checking"
    property string errorMessage: ""
    property string actionError: ""
    property string request: ""
    property string queued: ""
    readonly property bool live: ["starting", "connecting", "running", "connected"].includes(serviceState)
    readonly property bool failed: serviceState === "failed" || serviceState === "unknown" || actionError !== ""
    readonly property string label: {
        if (failed) return Plasmoid.configuration.errorText || i18n("Error")
        switch (serviceState) {
        case "connected": return Plasmoid.configuration.connectedText || i18n("Connected")
        case "running": return Plasmoid.configuration.runningText || i18n("Running")
        case "starting": return Plasmoid.configuration.startingText || i18n("Starting…")
        case "connecting": return Plasmoid.configuration.connectingText || i18n("Connecting…")
        case "stopping": return Plasmoid.configuration.stoppingText || i18n("Stopping…")
        case "stopped": return Plasmoid.configuration.stoppedText || i18n("Stopped")
        default: return Plasmoid.configuration.checkingText || i18n("Checking…")
        }
    }
    readonly property string iconKey: failed ? "error" : ["connected", "running"].includes(serviceState) ? "active"
        : serviceState === "stopping" ? "stopping" : serviceState === "stopped" ? "stopped" : "starting"
    readonly property string nextAction: ["checking", "stopping"].includes(serviceState) ? ""
        : serviceState === "unknown" ? i18n("Click to check again.")
        : live ? i18n("Click to stop.") : failed ? i18n("Click to retry.")
        : i18n("Click to start.")

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    Plasmoid.icon: Qt.resolvedUrl("../images/icon.svg").toString()
    Plasmoid.status: failed ? PlasmaCore.Types.NeedsAttentionStatus : PlasmaCore.Types.ActiveStatus
    toolTipMainText: ""
    toolTipSubText: {
        const text = tooltipRunner.output || Plasmoid.configuration.tooltipText
            || [actionError || errorMessage, nextAction].filter(Boolean).join("\n")
        return Plasmoid.configuration.tooltipShowStatus ? [text, label].filter(Boolean).join(" ") : text
    }
    toolTipTextFormat: Text.PlainText
    preferredRepresentation: fullRepresentation

    CommandText {
        id: statusRunner
        command: Plasmoid.configuration.showStatusText && Plasmoid.configuration.statusUseCommand
            ? Plasmoid.configuration.statusCommand.trim() : ""
        refreshSeconds: Plasmoid.configuration.statusInterval
    }

    CommandText {
        id: tooltipRunner
        command: Plasmoid.configuration.tooltipUseCommand ? Plasmoid.configuration.tooltipCommand.trim() : ""
        refreshSeconds: Plasmoid.configuration.tooltipInterval
    }

    function scheduleTextRefresh() {
        statusRunner.refreshAfterStateChange()
        tooltipRunner.refreshAfterStateChange()
    }

    onServiceStateChanged: scheduleTextRefresh()
    onFailedChanged: scheduleTextRefresh()

    function quote(arg) {
        return "'" + String(arg).replace(/'/g, "'\\''") + "'"
    }

    function run(action) {
        if (request) {
            if (action !== "status") queued = action
            return
        }
        poll.stop()
        const path = decodeURIComponent(Qt.resolvedUrl("../code/control").toString().slice(7))
        const args = ["bash", path, action, Plasmoid.id]
        if (action === "start") args.push(Plasmoid.configuration.launchCommand)
        request = action
        if (action !== "status") {
            actionError = ""
            errorMessage = ""
        }
        executor.connectSource(args.map(quote).join(" "))
    }

    function toggle() {
        if (queued || (request && request !== "status") || ["stopping", "checking"].includes(serviceState)) return
        run(serviceState === "unknown" ? "status" : live ? "stop" : "start")
    }

    Component.onCompleted: {
        const config = Plasmoid.configuration
        if (!config.commandMigrated) {
            if (config.customScript) {
                config.launchCommand = config.command
            }
            config.commandMigrated = true
        }
        run("status")
    }
    Plasmoid.onActivated: toggle()
    Connections {
        target: Plasmoid
        function onDestroyedChanged(destroyed) {
            if (destroyed) root.run("stop")
        }
    }

    P5Support.DataSource {
        id: executor
        engine: "executable"
        onNewData: function(source, data) {
            if (data["exit code"] === undefined) return
            disconnectSource(source)
            const action = root.request
            root.request = ""
            if (data["exit code"] !== 0 || data["exit status"] !== 0) {
                const error = TerminalText.plainText(data.stderr) || i18n("Command failed (exit %1).", data["exit code"])
                if (action === "status") {
                    root.serviceState = "unknown"
                    root.errorMessage = error
                } else {
                    root.actionError = error
                }
            } else if (action === "status") {
                const lines = TerminalText.plainText(data.stdout).split("\n")
                root.serviceState = lines.shift()
                root.errorMessage = lines.join("\n")
            } else {
                root.serviceState = action === "stop" ? "stopping" : "starting"
            }

            if (root.queued) {
                const next = root.queued
                root.queued = ""
                Qt.callLater(() => root.run(next))
            } else {
                poll.interval = action !== "status" ? 100 : root.live || root.serviceState === "stopping" ? 1000 : 5000
                poll.restart()
            }
        }
    }

    Timer {
        id: poll
        onTriggered: root.run("status")
    }

    fullRepresentation: PC.ToolButton {
        id: button
        readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
        readonly property bool horizontalPanel: Plasmoid.formFactor === PlasmaCore.Types.Horizontal
        readonly property bool compactPanel: horizontalPanel && !Plasmoid.configuration.showStatusText
        implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
        implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
        Layout.minimumWidth: vertical ? Kirigami.Units.iconSizes.small : implicitWidth
        Layout.preferredWidth: implicitWidth
        Layout.maximumWidth: compactPanel ? implicitWidth : Infinity
        Layout.preferredHeight: implicitHeight
        Accessible.name: i18n("Switcher · %1", root.label)
        Accessible.description: root.toolTipSubText
        onClicked: root.toggle()

        PlasmaCore.ToolTipArea {
            anchors.fill: parent
            z: 1
            active: true
            mainText: root.toolTipMainText
            subText: root.toolTipSubText
            textFormat: root.toolTipTextFormat
        }

        Binding {
            when: button.compactPanel
            button.leftPadding: 0
            button.rightPadding: 0
        }

        contentItem: GridLayout {
            columns: button.vertical ? 1 : 2
            columnSpacing: Kirigami.Units.smallSpacing
            rowSpacing: 0

            Item {
                Layout.preferredWidth: button.horizontalPanel && root.height > 0
                    ? Math.max(0, root.height - button.topPadding - button.bottomPadding) : Kirigami.Units.iconSizes.medium
                Layout.preferredHeight: button.vertical && root.width > 0
                    ? Math.max(0, root.width - button.leftPadding - button.rightPadding) : Kirigami.Units.iconSizes.medium
                Layout.fillWidth: true
                Layout.fillHeight: true

                StateIcon {
                    anchors.centerIn: parent
                    width: Math.min(parent.width, parent.height)
                    height: width
                    theme: Plasmoid.configuration.iconTheme
                    stateKey: root.iconKey
                    overrideUrl: Plasmoid.configuration[root.iconKey + "Icon"] || ""
                }
            }

            PC.Label {
                visible: Plasmoid.configuration.showStatusText
                Layout.fillWidth: button.vertical
                Layout.minimumWidth: 0
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                id: statusLabel
                text: statusRunner.output || root.label
                Binding {
                    target: statusLabel
                    property: "font.family"
                    value: Plasmoid.configuration.statusFontFamily
                    when: Plasmoid.configuration.statusFontFamily !== ""
                }
                Binding {
                    target: statusLabel
                    property: "font.pointSize"
                    value: Plasmoid.configuration.statusFontSize
                    when: Plasmoid.configuration.statusFontSize > 0
                }
                textFormat: Text.PlainText
            }
        }
    }
}
