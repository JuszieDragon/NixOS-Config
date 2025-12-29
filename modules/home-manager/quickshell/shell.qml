import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PanelWindow {
  anchors { top: true; left: true; right: true }
  implicitHeight: 30
  color: "#1a1b26"

  id: root

  property color colBg: "#1a1b26"
  property color colFg: "#a9b1d6"
  property color colMuted: "#444b6a"
  property color colCyan: "#0db9d7"
  property color colPurple: "#ad8ee6"
  property color colRed: "#f7768e"
  property color colYellow: "#e0af68"
  property color colBlue: "#7aa2f7"
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14

  property string kernelVersion: "Linux"
  property int cpuUsage: 0
  property int memUsage: 0
  property int diskUsage: 0
  property int volumeLevel: 0
  property string activeWindow: "Window"
  property string currentLayout: "Tile"

  property var lastCpuIdle: 0
  property var lastCpuTotal: 0

  Process {
    id: kernelProc
    command: ["uname", "-r"]
    stdout: SplitParser {
      onRead: data => { if (data) kernelVersion = data.trim() }
    }
    Component.onCompleted: running = true
  }

  Process {
    id: cpuProc
    command: ["sh", "-c", "head -1 /proc/stat"]

    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var p = data.trim().split(/\s+/)
        var idle = parseInt(p[4]) + parseInt(p[5])
        var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
        if (lastCpuTotal > 0) {
          cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)))
        }
        lastCpuTotal = total
        lastCpuIdle = idle
      }
    }

    Component.onCompleted: running = true
  }

  Process {
    id: memProc
    command: ["sh", "-c", "free | grep Mem"]

    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var parts = data.trim().split(/\s+/)
        var total = parseInt(parts[1]) || 1
        var used = parseInt(parts[2]) || 0
        memUsage = Math.round(100 * used / total)
      }
    }

    Component.onCompleted: running = true
  }

  Process {
    id: diskProc
    command: ["sh", "-c", "df / | tail -1"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var parts = data.trim().split(/\s+/)
        var percentStr = parts[4] || "0%"
        diskUsage = parseInt(percentStr.replace('%', '')) || 0
      }
    }
    Component.onCompleted: running = true
  }

  Process {
    id: volProc
    command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var match = data.match(/Volume:\s*([\d.]+)/)
        if (match) {
          volumeLevel = Math.round(parseFloat(match[1]) * 100)
        }
      }
    }
    Component.onCompleted: running = true
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      cpuProc.running = true
      memProc.running = true
      diskProc.running = true
      volProc.running = true
    }
  }

  RowLayout {
    anchors {
      fill: parent
      margins: 8
    }

    Item { Layout.fillWidth: true }

    Text {
      text: kernelVersion
      color: root.colRed
      font.pixelSize: root.fontSize
      font.family: root.fontFamily
      font.bold: true
      Layout.rightMargin: 8
    }

    Rectangle {
      Layout.preferredWidth: 1
      Layout.preferredHeight: 16
      Layout.alignment: Qt.AlignVCenter
      Layout.leftMargin: 0
      Layout.rightMargin: 8
      color: root.colMuted
    }

    Text {
      text: "CPU: " + cpuUsage + "%"
      color: root.colYellow
      font.pixelSize: root.fontSize
      font.family: root.fontFamily
      font.bold: true
      Layout.rightMargin: 8
    }

    Rectangle {
      Layout.preferredWidth: 1
      Layout.preferredHeight: 16
      Layout.alignment: Qt.AlignVCenter
      Layout.leftMargin: 0
      Layout.rightMargin: 8
      color: root.colMuted
    }

    Text {
      text: "Mem: " + memUsage + "%"
      color: root.colCyan
      font.pixelSize: root.fontSize
      font.family: root.fontFamily
      font.bold: true
      Layout.rightMargin: 8
    }

    Rectangle {
      Layout.preferredWidth: 1
      Layout.preferredHeight: 16
      Layout.alignment: Qt.AlignVCenter
      Layout.leftMargin: 0
      Layout.rightMargin: 8
      color: root.colMuted
    }

    Text {
      text: "Disk: " + diskUsage + "%"
      color: root.colBlue
      font.pixelSize: root.fontSize
      font.family: root.fontFamily
      font.bold: true
      Layout.rightMargin: 8
    }

    Rectangle {
      Layout.preferredWidth: 1
      Layout.preferredHeight: 16
      Layout.alignment: Qt.AlignVCenter
      Layout.leftMargin: 0
      Layout.rightMargin: 8
      color: root.colMuted
    }

    Text {
      text: "Vol: " + volumeLevel + "%"
      color: root.colPurple
      font.pixelSize: root.fontSize
      font.family: root.fontFamily
      font.bold: true
      Layout.rightMargin: 8
    }

    Rectangle {
      Layout.preferredWidth: 1
      Layout.preferredHeight: 16
      Layout.alignment: Qt.AlignVCenter
      Layout.leftMargin: 0
      Layout.rightMargin: 8
      color: root.colMuted
    }

    Text {
      id: clockText
      text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
      color: root.colCyan
      font.pixelSize: root.fontSize
      font.family: root.fontFamily
      font.bold: true
      Layout.rightMargin: 8

      Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockText.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - hh:mm:ss ap")
      }
    }
  } 
}

