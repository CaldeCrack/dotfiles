pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

// Wraps Quickshell.Services.Mpris so the music tab (and anything else) never
// touches an MprisPlayer directly. Two jobs: (1) pick a sensible default
// active player (mpd-mpris) while still exposing the full player list for
// the extra-actions selector, and (2) paper over the fact that MPRIS
// position doesn't tick on its own — something has to poll it.
Singleton {
    id: root

    // --- Player selection --------------------------------------------------

    // mpd-mpris registers under a fixed, well-known bus name. Matching on
    // that is more reliable than matching on `identity`, which is just a
    // free-form display string and not guaranteed stable.
    readonly property string mpdBusName: "org.mpris.MediaPlayer2.mpd"

    // Raw list, exposed as-is — the extra-actions player selector needs
    // every player (MPD + any browser tab currently playing), not just
    // whichever one is active.
    readonly property var players: Mpris.players

    readonly property var mpdPlayer: {
        for (const p of players.values) {
            if (p.dbusName === mpdBusName)
                return p;
        }
        return null;
    }

    property var activePlayer: null

    function updateActivePlayer() {
        // Don't override a player explicitly selected by the user.
        if (activePlayer)
            return;

        if (mpdPlayer)
            setActivePlayer(mpdPlayer);
    }

    // MPRIS may already have players when this singleton is created,
    // such as when Quickshell is reloaded during development.
    Timer {
        interval: 100
        running: true
        repeat: false

        onTriggered: root.updateActivePlayer()
    }

    Connections {
        target: root.players

        function onObjectInsertedPost(object, index) {
            root.watchPlayerPlayback(object);
            root.updateActivePlayer();
        }

        function onObjectRemovedPost() {
            if (root.activePlayer && root.players.values.indexOf(root.activePlayer) === -1) {
                root.activePlayer = null;
                root.updateActivePlayer();
            }
        }
    }

    function considerPlayingPlayer(player) {
        if (player.playbackState !== MprisPlaybackState.Playing)
            return;
        if (player === root.activePlayer)
            return;
        if (root.activePlayer && root.activePlayer.playbackState === MprisPlaybackState.Playing)
            return;

        root.setActivePlayer(player);
    }

    function watchPlayerPlayback(player) {
        player.playbackStateChanged.connect(() => {
            root.considerPlayingPlayer(player);
        });

        // A newly registered player can already be playing before we connect
        // to its playbackStateChanged signal.
        root.considerPlayingPlayer(player);
    }

    // Covers players MPRIS already had before this singleton finished
    // initializing (same "Quickshell reloaded during development, or
    // players connected before the shell started" case the startup Timer
    // above exists for) — objectInsertedPost only fires for players
    // added *after* this point, so anything already present needs to be
    // caught here instead.
    Component.onCompleted: {
        for (const p of root.players.values)
            root.watchPlayerPlayback(p);
    }

    Connections {
        target: root.activePlayer

        function onTrackTitleChanged() {
            if (root.activePlayer.trackTitle)
                root.cachedTitle = root.activePlayer.trackTitle;
        }

        function onTrackArtistChanged() {
            if (root.activePlayer.trackArtist)
                root.cachedArtist = root.activePlayer.trackArtist;
        }

        function onTrackAlbumChanged() {
            if (root.activePlayer.trackAlbum)
                root.cachedAlbum = root.activePlayer.trackAlbum;
        }

        function onTrackArtUrlChanged() {
            if (root.activePlayer.trackArtUrl)
                root.cachedArtUrl = root.activePlayer.trackArtUrl;
        }

        function onLengthChanged() {
            if (root.activePlayer.length && root.activePlayer.length > root.cachedLength) {
                root.cachedLength = root.activePlayer.length;
            }
        }
    }

    function setActivePlayer(player) {
        activePlayer = player;

        if (!player) {
            cachedTitle = "";
            cachedArtist = "";
            cachedAlbum = "";
            cachedArtUrl = "";
            cachedLength = 0;
            return;
        }

        cachedTitle = player.trackTitle || "";
        cachedArtist = player.trackArtist || "";
        cachedAlbum = player.trackAlbum || "";
        cachedArtUrl = player.trackArtUrl || "";
        cachedLength = player.length || 0;
    }

    readonly property bool available: activePlayer !== null

    // --- Metadata cache ------------------------------------------------------
    //
    // Some browser MPRIS implementations (observed with Zen + YouTube Music)
    // intermittently stop advertising optional metadata (notably trackArtUrl
    // and length) without the track actually changing. Cache the last valid
    // values so transient metadata regressions don't blank the UI.

    property string cachedTitle: ""
    property string cachedArtist: ""
    property string cachedAlbum: ""
    property string cachedArtUrl: ""
    property real cachedLength: 0

    // --- Metadata, read-through -------------------------------------------

    readonly property string title: cachedTitle
    readonly property string artist: cachedArtist
    readonly property string album: cachedAlbum
    readonly property string artUrl: cachedArtUrl
    readonly property real length: cachedLength

    readonly property bool isPlaying: available && activePlayer.playbackState === MprisPlaybackState.Playing
    readonly property bool canGoNext: available && activePlayer.canGoNext
    readonly property bool canGoPrevious: available && activePlayer.canGoPrevious
    readonly property bool canSeek: available && activePlayer.canSeek

    readonly property bool shuffle: available && activePlayer.shuffle
    readonly property int loopState: available ? activePlayer.loopState : MprisLoopState.None

    // --- Position ------------------------------------------------------------
    //
    // Per Quickshell's own MprisPlayer docs: reading `position` always
    // returns the correct current value, but the property deliberately
    // does NOT emit reactive change notifications during normal playback
    // (only on a nonlinear jump) — to avoid wasting CPU on a value nothing
    // may be watching. That means a plain declarative binding to it, left
    // alone, will only ever update once and then go stale — which is what
    // was actually causing the "stuck at start after restart" bug: not a
    // gating issue, but this property fundamentally not renotifying on its
    // own. The documented fix is to periodically emit positionChanged()
    // manually while something is actively monitoring it, which forces
    // this binding to re-evaluate.
    readonly property real position: available ? activePlayer.position : 0

    // Only needs to run while playing — a paused position is static and
    // already correct the moment it's read once, no forcing required.
    Timer {
        interval: 500
        running: root.isPlaying
        repeat: true
        onTriggered: root.activePlayer.positionChanged()
    }

    // --- Transport methods, thin pass-throughs ------------------------------
    //
    // Kept here so tab components never touch activePlayer directly and
    // don't need to care whether there are 0 or several players.

    function playPause() {
        if (available)
            activePlayer.togglePlaying();
    }

    function next() {
        if (available && canGoNext)
            activePlayer.next();
    }

    function previous() {
        if (available && canGoPrevious)
            activePlayer.previous();
    }

    function seek(positionSeconds) {
        // Deliberately not gated on canSeek: if mpd-mpris/Quickshell ever
        // misreports that flag as false, gating here means this becomes a
        // silent no-op — the backend position never actually changes, and
        // the poll timer then correctly (from its point of view) snaps the
        // UI back to the real, unchanged position. That's the "moves for a
        // moment then reverts" symptom. Worst case with the gate removed:
        // an unsupported player ignores the assignment harmlessly.
        if (available)
            activePlayer.position = positionSeconds;
    }

    function toggleShuffle() {
        if (available)
            activePlayer.shuffle = !activePlayer.shuffle;
    }

    // None -> Track -> Playlist -> None. mpd-mpris supports all three; a
    // generic browser player usually implements none of it — MPRIS has no
    // canLoop capability flag to check ahead of time, so this may just
    // silently no-op on players that don't support it.
    function cycleLoop() {
        if (!available)
            return;
        const order = [MprisLoopState.None, MprisLoopState.Track, MprisLoopState.Playlist];
        const idx = order.indexOf(activePlayer.loopState);
        activePlayer.loopState = order[(idx + 1) % order.length];
    }

    // Icon resolution moved to widgets/Icon.qml's `appId` mode — any
    // consumer that needs an icon for `desktopEntry` now uses
    // `Icon { appId: Media.activePlayer.desktopEntry }` directly instead
    // of resolving a name here first. Kept the raw `desktopEntry` exposed
    // via activePlayer for anything that still wants it directly.
}
