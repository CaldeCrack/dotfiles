pragma Singleton

import QtQuick

QtObject {
    function display(key) {
        switch (key) {
        case "SUPER":
            return "󰣇";
        case "ENTER":
            return "↵";
        case "TAB":
            return "⇥";
        case "LEFT":
            return "←";
        case "RIGHT":
            return "→";
        case "UP":
            return "↑";
        case "DOWN":
            return "↓";
        case "HORIZONTAL":
            return "←/→";
        case "VERTICAL":
            return "↑/↓";
        case "ARROWS":
            return "←/↑/↓/→";
        default:
            return key;
        }
    }

    function isSpecial(key) {
        switch (key) {
        case "SUPER":
        case "ENTER":
        case "TAB":
        case "LEFT":
        case "RIGHT":
        case "UP":
        case "DOWN":
        case "HORIZONTAL":
        case "VERTICAL":
        case "ARROWS":
            return true;
        default:
            return false;
        }
    }
}
