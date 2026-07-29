pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config as Config

// Weather service — fetches from wttr.in's JSON API (?format=j1), no API
// key required. Location/units come from Config.Settings.weather. Refetches
// on a timer, and refresh() is exposed for a manual/on-demand trigger.
//
// Sits alongside the other services/ singletons, same multi-singleton-per-
// folder convention as Config.Colors/Config.Settings: import as
//   import qs.services as Services
// then reference Services.Weather.* directly.
Singleton {
    id: root

    property bool loading: false
    property string errorMessage: ""

    property date lastFetchTime

    readonly property string lastFetchTimeString: lastFetchTime ? Qt.formatDateTime(lastFetchTime, "hh:mm") : ""

    // Full parsed payload kept around for anything not surfaced below —
    // avoids adding a new property here every time a section wants one
    // more field out of wttr.in's fairly large response.
    property var raw: null

    property string locationName: ""

    // ---- Organized outputs -------------------------------------------

    // { tempC, minTempC, maxTempC, feelsLikeC, humidity, windSpeedKmph,
    //   windDir, weatherCode, iconName, description }
    // minTempC/maxTempC come from today's forecast day entry, since
    // current_condition itself has no min/max of its own.
    property var current: ({})

    // Up to 5 entries, nearest first: { time ("HH:00"), minTempC, maxTempC,
    // weatherCode, iconName, description }.
    //
    // wttr.in's "hourly" data is actually 3-hour steps, not true hourly, so
    // "time" is whichever slot that granularity lands on, formatted onto a
    // clean HH:00 boundary. There's no real min/max for a single point-in-
    // time reading — minTempC and maxTempC are both set to that slot's temp
    // so hourly and daily entries share the same shape either way.
    property var hourlyForecast: []

    // Up to 5 entries: { dayName, minTempC, maxTempC, weatherCode,
    // iconName, description }. wttr.in's free API only returns 3 days in
    // practice, so this will usually have 3 entries even though up to 5 are
    // requested — slice(0, 5) just takes whatever's actually available.
    property var dailyForecast: []

    // ---- Manual refresh --------------------------------------------------
    // Exposed for an on-demand trigger (e.g. a refresh button), separate
    // from the periodic Timer below.

    function refresh() {
        loading = true;
        errorMessage = "";
        fetchProcess.running = false; // cancel any in-flight fetch first
        fetchProcess.running = true;
    }

    function buildUrl() {
        const location = encodeURIComponent(Config.Settings.weather.location);
        const units = Config.Settings.weather.units === "imperial" ? "u" : Config.Settings.weather.units === "metric" ? "m" : "";
        const unitsParam = units ? "&" + units : "";
        return "https://wttr.in/" + location + "?format=j1" + unitsParam;
    }

    Process {
        id: fetchProcess
        command: ["curl", "-s", root.buildUrl()]

        stdout: StdioCollector {
            onStreamFinished: {
                root.loading = false;
                try {
                    root.applyPayload(JSON.parse(text));
                    root.lastFetchTime = new Date();
                } catch (e) {
                    root.errorMessage = "Failed to parse weather data: " + e;
                }
            }
        }
    }

    // wttr.in's date-only strings ("2026-07-28") get parsed as UTC midnight
    // by `new Date(str)`, which can land on the wrong local day depending on
    // timezone — anywhere west of UTC (e.g. Chile) that's a real off-by-one
    // risk right around midnight. Splitting the string and using the
    // local-time Date constructor avoids that entirely.
    function parseWttrDate(dateStr) {
        const parts = dateStr.split("-").map(Number);
        return new Date(parts[0], parts[1] - 1, parts[2]);
    }

    // wttr.in's hourly "time" field is "0".."2100" (HHMM, no leading zeros,
    // no colon), always landing on a 3-hour boundary — this just formats it
    // onto a clean "HH:00" string.
    function formatWttrTime(timeStr) {
        const padded = timeStr.padStart(4, "0");
        return padded.slice(0, 2) + ":00";
    }

    // Parses a 12-hour "HH:MM AM/PM" string (wttr.in's astronomy block
    // format) onto the given calendar date, returning a Date.
    function parseAmPmTime(dateObj, timeStr) {
        const match = /(\d+):(\d+)\s*(AM|PM)/i.exec(timeStr || "");
        if (!match)
            return null;

        let hour = parseInt(match[1], 10);
        const minute = parseInt(match[2], 10);
        const meridiem = match[3].toUpperCase();
        if (meridiem === "PM" && hour !== 12)
            hour += 12;
        if (meridiem === "AM" && hour === 12)
            hour = 0;

        const result = new Date(dateObj);
        result.setHours(hour, minute, 0, 0);
        return result;
    }

    // Whether entryDate falls between that day's actual sunrise/sunset —
    // more accurate than a fixed hour cutoff since sunrise/sunset shifts
    // with season and location. astronomy is a day's astronomy[0] object
    // (or null, in which case this defaults to "day" rather than guessing).
    function isDaytime(entryDate, astronomy) {
        if (!astronomy)
            return true;

        const sunrise = parseAmPmTime(entryDate, astronomy.sunrise);
        const sunset = parseAmPmTime(entryDate, astronomy.sunset);
        if (!sunrise || !sunset)
            return true;

        return entryDate >= sunrise && entryDate < sunset;
    }

    function applyPayload(data) {
        raw = data;

        const area = data.nearest_area && data.nearest_area[0];
        locationName = area ? [area.areaName[0].value, area.country[0].value].filter(Boolean).join(", ") : Config.Settings.weather.location;

        const days = data.weather || [];
        const todayEntry = days[0];
        const todayAstronomy = todayEntry && todayEntry.astronomy ? todayEntry.astronomy[0] : null;

        // ---- Current -----------------------------------------------------

        const cc = data.current_condition && data.current_condition[0];
        if (cc) {
            const code = parseInt(cc.weatherCode, 10);
            const now = new Date();
            current = {
                tempC: parseFloat(cc.temp_C),
                minTempC: todayEntry ? parseFloat(todayEntry.mintempC) : NaN,
                maxTempC: todayEntry ? parseFloat(todayEntry.maxtempC) : NaN,
                feelsLikeC: parseFloat(cc.FeelsLikeC),
                humidity: parseInt(cc.humidity, 10),
                windSpeedKmph: parseFloat(cc.windspeedKmph),
                windDir: cc.winddir16Point || "",
                weatherCode: code,
                iconName: iconForCode(code, isDaytime(now, todayAstronomy)),
                description: cc.weatherDesc && cc.weatherDesc[0] ? cc.weatherDesc[0].value.trim() : ""
            };
        }

        // ---- Hourly (next 5 slots, spanning day boundaries if needed) -----

        const now2 = new Date();
        const allHourly = [];

        for (const day of days) {
            const dayDate = parseWttrDate(day.date);
            const astronomy = day.astronomy && day.astronomy[0] ? day.astronomy[0] : null;

            for (const h of (day.hourly || [])) {
                const hhmm = parseInt(h.time, 10); // e.g. 0, 300, 1800
                const hour = Math.floor(hhmm / 100);
                const entryDate = new Date(dayDate);
                entryDate.setHours(hour, 0, 0, 0);

                const code = parseInt(h.weatherCode, 10);

                allHourly.push({
                    dateTime: entryDate,
                    time: formatWttrTime(h.time),
                    tempC: parseFloat(h.tempC),
                    humidity: parseInt(h.humidity, 10),
                    weatherCode: code,
                    iconName: iconForCode(code, isDaytime(entryDate, astronomy)),
                    description: h.weatherDesc && h.weatherDesc[0] ? h.weatherDesc[0].value.trim() : ""
                });
            }
        }

        hourlyForecast = allHourly.sort((a, b) => a.dateTime - b.dateTime).filter(entry => entry.dateTime > now2).slice(0, 5).map(entry => ({
                    time: entry.time,
                    tempC: entry.tempC,
                    humidity: entry.humidity,
                    weatherCode: entry.weatherCode,
                    iconName: entry.iconName,
                    description: entry.description
                }));

        // ---- Daily (up to 5 — wttr.in's free API typically returns 3) -----

        dailyForecast = days.slice(0, 5).map(day => {
            // Representative condition for the day: the 12:00 slot (index 4
            // in the 3-hourly array) reads better for an icon/summary than
            // midnight would.
            const hourly = day.hourly || [];
            const midday = hourly[4] || hourly[0] || null;
            const code = midday ? parseInt(midday.weatherCode, 10) : 0;

            const middayDate = parseWttrDate(day.date);
            middayDate.setHours(12, 0, 0, 0);
            const astronomy = day.astronomy && day.astronomy[0] ? day.astronomy[0] : null;

            return {
                dayName: Qt.formatDate(parseWttrDate(day.date), "dddd"),
                minTempC: parseFloat(day.mintempC),
                maxTempC: parseFloat(day.maxtempC),
                humidity: parseInt(midday.humidity, 10),
                weatherCode: code,
                iconName: iconForCode(code, isDaytime(middayDate, astronomy)),
                description: midday && midday.weatherDesc && midday.weatherDesc[0] ? midday.weatherDesc[0].value.trim() : ""
            };
        });
    }

    // ---- weatherCode -> bundled icon name -----------------------------
    // wttr.in's weatherCode mostly comes from WorldWeatherOnline's condition
    // table (~35 distinct codes — e.g. "Patchy light rain", "Moderate rain
    // shower", "Torrential rain shower" are all separately coded), plus a
    // couple of extra codes (149 "Smoky haze", 152 "Smog") that show up in
    // practice but aren't part of that standard table.
    // Expects assets/icons/weather/<name>.svg for each category below.

    readonly property var _codeToIcon: ({
            113: "clear",
            116: "partly-cloudy",
            119: "cloudy",
            122: "overcast",
            143: "fog",
            149: "fog"     // Smoky haze (non-standard, seen in practice)
            ,
            152: "fog"     // Smog (non-standard, seen in practice)
            ,
            176: "sprinkle",
            179: "snow",
            182: "sleet",
            185: "sleet",
            200: "thunderstorm",
            227: "snow",
            230: "snow",
            248: "fog",
            260: "fog",
            263: "sprinkle",
            266: "sprinkle",
            281: "sleet",
            284: "sleet",
            293: "sprinkle",
            296: "sprinkle",
            299: "drizzle",
            302: "drizzle",
            305: "rain",
            308: "rain",
            311: "sleet",
            314: "sleet",
            317: "sleet",
            320: "sleet",
            323: "snow",
            326: "snow",
            329: "snow",
            332: "snow",
            335: "snow",
            338: "snow",
            350: "hail",
            353: "sprinkle",
            356: "rain",
            359: "rain",
            362: "sleet",
            365: "sleet",
            368: "snow",
            371: "snow",
            374: "sleet",
            377: "hail",
            386: "thunderstorm",
            389: "thunderstorm",
            392: "thunderstorm",
            395: "thunderstorm"
        })

    // Only clear/partly-cloudy have day-/night- variants (per the actual
    // SVGs available) — isDay is ignored for every other category, and
    // also tolerated as undefined by callers that don't care (falls
    // through to the plain category name).
    function iconForCode(code, isDay) {
        const category = _codeToIcon[code] || "default";
        const hasDayNightVariant = category === "clear" || category === "partly-cloudy";
        const variant = hasDayNightVariant && typeof isDay === "boolean" ? (isDay ? "day-" : "night-") + category : category;
        return "weather/" + variant;
    }

    // ---- Periodic refresh ------------------------------------------------

    Timer {
        interval: 15 * 60 * 1000 // 15 minutes
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
