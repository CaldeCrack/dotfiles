pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // All usage values are 0-100. temperature is in °C.
    property real cpuUsage: 0
    property real memoryUsage: 0
    property real diskUsage: 0
    property real gpuUsage: 0
    property real temperature: 0

    // cpuUsage needs a delta between two /proc/stat reads, not a single
    // snapshot — these hold the previous read.
    property real _prevCpuTotal: 0
    property real _prevCpuIdle: 0

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
            diskProc.running = true
            gpuProc.running = true
            tempProc.running = true
        }
    }

    // --- CPU ---
    Process {
        id: cpuProc
        command: ["sh", "-c", "grep '^cpu ' /proc/stat"]
        stdout: SplitParser {
            onRead: line => {
                const parts = line.trim().split(/\s+/).slice(1).map(Number)
                if (parts.length < 5)
                    return

                const idle = parts[3] + parts[4] // idle + iowait
                const total = parts.reduce((a, b) => a + b, 0)

                const totalDelta = total - root._prevCpuTotal
                const idleDelta = idle - root._prevCpuIdle

                if (root._prevCpuTotal !== 0 && totalDelta > 0)
                    root.cpuUsage = Math.max(0, Math.min(100, 100 * (1 - idleDelta / totalDelta)))

                root._prevCpuTotal = total
                root._prevCpuIdle = idle
            }
        }
    }

    // --- Memory ---
    Process {
        id: memProc
        command: ["sh", "-c", "grep -E '^(MemTotal|MemAvailable):' /proc/meminfo"]
        property real total: 0
        stdout: SplitParser {
            onRead: line => {
                const match = line.match(/(\w+):\s+(\d+)/)
                if (!match)
                    return

                const key = match[1]
                const value = Number(match[2])

                if (key === "MemTotal") {
                    memProc.total = value
                } else if (key === "MemAvailable" && memProc.total > 0) {
                    root.memoryUsage = Math.max(0, Math.min(100, 100 * (1 - value / memProc.total)))
                }
            }
        }
    }

    // --- Disk (root filesystem) ---
    Process {
        id: diskProc
        command: ["sh", "-c", "df --output=pcent / | tail -1"]
        stdout: SplitParser {
            onRead: line => {
                const value = Number(line.replace("%", "").trim())
                if (!isNaN(value))
                    root.diskUsage = value
            }
        }
    }

    // --- GPU ---
    // Tries nvidia-smi first, falls back to the amdgpu/intel sysfs busy
    // counter. Leaves gpuUsage at its last known value if neither exists
    // (e.g. no discrete GPU, or the querying tool isn't installed).
    Process {
        id: gpuProc
        command: ["sh", "-c",
            "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null " +
            "|| cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null"]
        stdout: SplitParser {
            onRead: line => {
                const value = Number(line.trim())
                if (!isNaN(value))
                    root.gpuUsage = value
            }
        }
    }

    // --- Temperature ---
    // Reads the first thermal zone. On multi-zone hardware this may not
    // be the CPU package sensor — swap the path for a specific zone
    // (check `cat /sys/class/thermal/thermal_zone*/type`) if it looks off.
    Process {
        id: tempProc
        command: ["sh", "-c", "cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null"]
        stdout: SplitParser {
            onRead: line => {
                const value = Number(line.trim())
                if (!isNaN(value))
                    root.temperature = value / 1000
            }
        }
    }
}
