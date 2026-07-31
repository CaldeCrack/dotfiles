import QtQuick
import QtQuick.Effects
import qs.config as Config
import qs.services as Services

Item {
    id: root

    // --- styling knobs -----------------------------------------------------
    property real blurAmount: 1.0
    property real blurMax: 64
    property real dimAmount: -0.35
    property real radius: 18

    readonly property bool hasArt: Services.Media.artUrl.length > 0

    // --- fallback ----------------------------------------------------------
    Rectangle {
        anchors.fill: parent
        visible: !root.hasArt
        radius: root.radius

        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop {
                position: 0.0
                color: Config.Colors.md3.primary_container
            }
            GradientStop {
                position: 1.0
                color: Config.Colors.md3.surface_container_lowest
            }
        }
    }

    // --- blurred artwork ---------------------------------------------------
    Item {
        anchors.fill: parent
        visible: root.hasArt

        Rectangle {
            id: maskShape
            anchors.fill: parent
            radius: root.radius
            color: "white"
            visible: false
            layer.enabled: true
        }

        Image {
            id: artSource
            anchors.fill: parent
            visible: false
            layer.enabled: true

            asynchronous: true
            source: root.hasArt ? Services.Media.artUrl : ""
            fillMode: Image.PreserveAspectCrop
        }

        // First pass: blur the artwork.
        MultiEffect {
            id: blurredArt
            anchors.fill: parent
            visible: false
            layer.enabled: true

            source: artSource

            blurEnabled: true
            blur: root.blurAmount
            blurMax: root.blurMax

            brightness: root.dimAmount
        }

        // Second pass: apply the rounded mask.
        MultiEffect {
            anchors.fill: parent

            source: blurredArt

            maskEnabled: true
            maskSource: maskShape
        }
    }
}
