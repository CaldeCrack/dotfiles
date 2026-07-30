pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

// Wraps Quickshell.Services.Mpris so the music tab (and anything else) never
// touches an MprisPlayer directly. Two jobs: (1) pick a sensible default
// active player (mpd-mpris) while still exposing the full player list for
// the extra-actions selector, and (2) paper over the fact that MPRIS
// position doesn't tick on its own — something has to poll it.
//
// NOTE: property/method names on MprisPlayer below (trackTitle, loopState,
// togglePlaying, etc.) are written against the Quickshell Mpris API as of
// last check — this has shifted across Quickshell versions before, so if
// something doesn't resolve, diff against `qs.Services.Mpris` docs/headers
// for the version actually installed before assuming the logic is wrong.
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

    // Everything below reads through this. Defaults to MPD when present,
    // overridable via setActivePlayer() from the selector.
    property var activePlayer: mpdPlayer

    // If the active player disappears (browser tab closed, mpd-mpris
    // restarted) fall back to MPD if it's there, else null — don't leave
    // activePlayer pointing at a dead object.
    onPlayersChanged: {
        if (activePlayer && players.indexOf(activePlayer) === -1)
            activePlayer = mpdPlayer;
    }

    function setActivePlayer(player) {
        activePlayer = player;
    }

    readonly property bool available: activePlayer !== null

    // --- Metadata, read-through -------------------------------------------

    readonly property string title: available ? (activePlayer.trackTitle || "") : ""
    readonly property string artist: available ? (activePlayer.trackArtist || "") : ""
    readonly property string album: available ? (activePlayer.trackAlbum || "") : ""
    readonly property string artUrl: available ? (activePlayer.trackArtUrl || "") : ""

    readonly property bool isPlaying: available && activePlayer.playbackState === MprisPlaybackState.Playing
    readonly property bool canGoNext: available && activePlayer.canGoNext
    readonly property bool canGoPrevious: available && activePlayer.canGoPrevious
    readonly property bool canSeek: available && activePlayer.canSeek

    readonly property bool shuffle: available && activePlayer.shuffle
    readonly property int loopState: available ? activePlayer.loopState : MprisLoopState.None

    readonly property real length: available ? activePlayer.length : 0

    // --- Position: polled, not pushed ---------------------------------------
    //
    // MPRIS only reports position on demand (plus a Seeked signal on
    // explicit seeks) — it does not stream continuously. positionTimer is
    // what makes the seekbar move smoothly while a track plays.

    property real position: available ? activePlayer.position : 0

    // Flip true while the seekbar widget is being dragged, so the timer
    // below doesn't overwrite `position` mid-gesture and fight the user's
    // thumb. The seekbar owns flipping this back to false + calling seek()
    // on release.
    property bool seekOverride: false

    Timer {
        interval: 500
        running: root.isPlaying && !root.seekOverride
        repeat: true
        onTriggered: root.position = root.activePlayer.position
    }

    onActivePlayerChanged: position = available ? activePlayer.position : 0

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
        if (available && canSeek)
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
}
