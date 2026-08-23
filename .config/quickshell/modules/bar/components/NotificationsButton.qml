import qs.config
import qs.services
import qs.widgets

// Bar button that toggles the notification center. Icon reflects state:
// silent mode takes visual precedence over unread (a deliberate choice —
// silent mode is a persistent setting the person actively chose, whereas
// unread is transient; showing bell-off communicates "you won't be
// notified" which matters more than "something arrived quietly" while
// muted). Flip the order below if you'd rather unread win.
BarButtonBase {
    id: root

    checked: Notifications.centerOpen
    tooltipText: _tooltipLabel
    onClicked: Notifications.toggleCenter()

    readonly property string _tooltipLabel: {
        if (Notifications.unreadCount === 1)
            return "1 new notification";
        if (Notifications.unreadCount > 0)
            return Notifications.unreadCount + " new notifications";
        return "Notification Center";
    }

    readonly property string _iconName: {
        if (Notifications.silentMode)
            return "notifications/bell-off";
        if (Notifications.unreadCount > 0)
            return "notifications/bell-dot";
        return "notifications/bell";
    }

    Icon {
        name: root._iconName
        size: 16
    }
}
