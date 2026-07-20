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

    // Raw byte counts for anything that wants more than the percentage —
    // deliberately left as plain bytes rather than pre-formatted into
    // GiB/GB here, since which unit reads as "normal" differs (memory is
    // conventionally shown in binary GiB, disk capacity in decimal GB to
    // match how drives are marketed). Let the component doing the
    // labelling decide.
    property real memoryTotalBytes: 0
    property real memoryUsedBytes: 0
    property real diskTotalBytes: 0
    property real diskUsedBytes: 0

    // Static hardware facts — read once, not on the 3s poll timer, since
    // these don't change at runtime.
    property real cpuMaxFrequencyMHz: 0
    property int cpuCoreCount: 0

    // 0 means "unknown", not "no VRAM" — expect this to stay 0 on
    // integrated GPUs (Intel iGPUs share system RAM rather than having a
    // fixed dedicated pool), not just when the query fails. Components
    // should treat 0 as "don't show a total" rather than "0 GB".
    property real gpuTotalVramBytes: 0

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

    Component.onCompleted: {
        cpuMaxFreqProc.running = true
        cpuCoreCountProc.running = true
        gpuVramProc.running = true
    }

    // --- CPU max frequency / core count (static, read once) ---
    Process {
        id: cpuMaxFreqProc
        command: ["sh", "-c", "cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq 2>/dev/null"]
        stdout: SplitParser {
            onRead: line => {
                const valueKhz = Number(line.trim())
                if (!isNaN(valueKhz))
                    root.cpuMaxFrequencyMHz = valueKhz / 1000
            }
        }
    }

    Process {
        id: cpuCoreCountProc
        command: ["sh", "-c", "nproc"]
        stdout: SplitParser {
            onRead: line => {
                const value = Number(line.trim())
                if (!isNaN(value))
                    root.cpuCoreCount = value
            }
        }
    }

    // --- GPU total VRAM (static, read once) ---
    // nvidia-smi reports MiB directly; the amdgpu sysfs file is bytes, so
    // it's converted to MiB with awk before hitting the same handler.
    // Nothing matches on Intel iGPUs — gpuTotalVramBytes stays 0, see the
    // property comment above.
    Process {
        id: gpuVramProc
        command: ["sh", "-c",
            "nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null " +
            "|| awk '{print $1/1024/1024}' /sys/class/drm/card0/device/mem_info_vram_total 2>/dev/null"]
        stdout: SplitParser {
            onRead: line => {
                const valueMib = Number(line.trim())
                if (!isNaN(valueMib))
                    root.gpuTotalVramBytes = valueMib * 1024 * 1024
            }
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
        property real total: 0 // kB, from /proc/meminfo
        stdout: SplitParser {
            onRead: line => {
                const match = line.match(/(\w+):\s+(\d+)/)
                if (!match)
                    return

                const key = match[1]
                const valueKb = Number(match[2])

                if (key === "MemTotal") {
                    memProc.total = valueKb
                    root.memoryTotalBytes = valueKb * 1024
                } else if (key === "MemAvailable" && memProc.total > 0) {
                    root.memoryUsage = Math.max(0, Math.min(100, 100 * (1 - valueKb / memProc.total)))
                    root.memoryUsedBytes = root.memoryTotalBytes - valueKb * 1024
                }
            }
        }
    }

    // --- Disk (root filesystem) ---
    // --block-size=1 forces byte units instead of df's locale-dependent
    // default block size, so diskTotalBytes/diskUsedBytes are plain bytes.
    Process {
        id: diskProc
        command: ["sh", "-c", "df --output=pcent,size,used --block-size=1 / | tail -1"]
        stdout: SplitParser {
            onRead: line => {
                const parts = line.trim().split(/\s+/)
                if (parts.length < 3)
                    return

                const pcent = Number(parts[0].replace("%", ""))
                const size = Number(parts[1])
                const used = Number(parts[2])

                if (!isNaN(pcent)) root.diskUsage = pcent
                if (!isNaN(size)) root.diskTotalBytes = size
                if (!isNaN(used)) root.diskUsedBytes = used
            }
        }
    }

    // --- GPU usage ---
    // Two independent, non-conflicting mechanisms — whichever one matches
    // your hardware is the one that actually writes to gpuUsage; the other
    // just fails silently.

    // Nvidia/AMD: cheap one-shot poll, same cadence as everything else.
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

    // Intel: unlike nvidia-smi/amdgpu sysfs, there's no simple one-shot
    // file read for i915/xe engine utilization — intel_gpu_top needs to
    // sample over an interval, and typically needs perf_event access
    // (root, or CAP_PERFMON / a relaxed perf_event_paranoid). Rather than
    // parse intel_gpu_top's own JSON-array-over-time output by hand, this
    // pipes it through `jq --unbuffered` so each line on stdout is just a
    // plain number, same shape as the other GPU path above.
    //
    // Started once (not on the timer) and left running — intel_gpu_top
    // controls its own sampling interval via -s.
    //
    // NOT verified against a real intel_gpu_top -J output — the
    // ".engines[\"Render/3D\"].busy" key is what community scripts for
    // this tool commonly use, but the exact schema has shifted across
    // igt-gpu-tools versions and GPU generations. If this stays at 0,
    // run `intel_gpu_top -J -s 1000` by hand for a few seconds and check
    // the real key name/path in the output, then adjust the jq filter.
    Process {
        id: gpuIntelProc
        running: true
        command: ["sh", "-c",
            "intel_gpu_top -J -s 1000 -o - 2>/dev/null " +
            "| jq --unbuffered -r '.engines[\"Render/3D\"].busy // empty'"]
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
