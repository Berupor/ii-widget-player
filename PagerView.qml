import qs.modules.common
import qs.modules.common.models
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell

/** One player at a time on a card tinted by its cover, app chips on top to switch. */
Item {
    id: root
    property var hero: null
    property var players: []
    readonly property bool playing: root.hero?.isPlaying ?? false
    signal picked(var player)

    implicitWidth: Appearance.sizes.mediaControlsWidth
    implicitHeight: surface.implicitHeight + Appearance.sizes.elevationMargin * 2

    CoverArt {
        id: cover
        player: root.hero
    }
    ColorQuantizer {
        id: quantizer
        source: cover.source
        depth: 0
        rescaleSize: 1
    }
    AdaptedMaterialScheme {
        id: artTint
        color: quantizer.colors[0] ?? Appearance.m3colors.m3secondaryContainer
    }
    readonly property QtObject tint: cover.source && quantizer.colors.length > 0 ? artTint : Appearance.colors
    // Art tints run light, too pale for 3:1 on a light card
    readonly property color accent: root.tint === artTint && !Appearance.m3colors.darkmode
        ? ColorUtils.mix(artTint.colPrimary, Appearance.colors.colOnLayer0, 0.55) : root.tint.colPrimary

    component TimeLabel: StyledText {
        font.pixelSize: Appearance.font.pixelSize.smaller
        font.features: { "tnum": 1 }
        color: Appearance.m3colors.m3onSurfaceVariant
    }
    component SkipButton: RippleButton {
        property string iconName
        implicitWidth: 48
        implicitHeight: 48
        buttonRadius: Appearance.rounding.full
        colBackgroundHover: root.tint.colSecondaryContainerHover
        colRipple: root.tint.colSecondaryContainerActive
        contentItem: MaterialSymbol {
            text: parent.iconName
            fill: 1
            iconSize: 28
            horizontalAlignment: Text.AlignHCenter
            color: Appearance.colors.colOnLayer0
        }
    }

    StyledRectangularShadow {
        target: surface
    }
    Rectangle {
        id: surface
        x: Appearance.sizes.elevationMargin
        y: Appearance.sizes.elevationMargin
        width: root.width - Appearance.sizes.elevationMargin * 2
        implicitHeight: root.hero ? content.implicitHeight + 32 : 200
        radius: Appearance.rounding.verylarge
        color: root.hero ? root.tint.colLayer0 : Appearance.colors.colLayer0
        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }

        EmptyState {
            visible: !root.hero
            anchors.centerIn: parent
        }

        ColumnLayout {
            id: content
            visible: !!root.hero
            x: 16
            y: 16
            width: parent.width - 32
            spacing: 12

            Flow {
                Layout.fillWidth: true
                spacing: 6
                Repeater {
                    model: root.players
                    delegate: RippleButton {
                        id: chip
                        required property var modelData
                        readonly property bool selected: chip.modelData === root.hero
                        implicitHeight: 32
                        implicitWidth: chipRow.implicitWidth + 24
                        buttonRadius: Appearance.rounding.full
                        colBackground: ColorUtils.transparentize(Appearance.colors.colOnLayer0, chip.selected ? 0.8 : 0.93)
                        colBackgroundHover: ColorUtils.transparentize(Appearance.colors.colOnLayer0, 0.75)
                        colRipple: ColorUtils.transparentize(Appearance.colors.colOnLayer0, 0.65)
                        onClicked: root.picked(chip.modelData)
                        contentItem: Item {
                            RowLayout {
                                id: chipRow
                                anchors.centerIn: parent
                                spacing: 6
                                PlayerAppIcon {
                                    player: chip.modelData
                                }
                                StyledText {
                                    visible: chip.selected
                                    text: chip.modelData.identity
                                    font.pixelSize: Appearance.font.pixelSize.smaller
                                    color: Appearance.colors.colOnLayer0
                                }
                                MaterialSymbol {
                                    visible: chip.modelData.isPlaying && !chip.selected
                                    text: "graphic_eq"
                                    iconSize: 16
                                    color: Appearance.colors.colOnLayer0
                                }
                            }
                        }
                    }
                }
            }

            PlayerArt {
                Layout.fillWidth: true
                Layout.preferredHeight: 176
                player: root.hero
                radius: Appearance.rounding.large
                colFallback: root.tint.colSecondaryContainer
                colOnFallback: root.tint.colOnSecondaryContainer
            }

            ColumnLayout {
                Layout.topMargin: 4
                spacing: 2
                StyledText {
                    Layout.fillWidth: true
                    text: StringUtils.cleanMusicTitle(root.hero?.trackTitle) || Translation.tr("Untitled")
                    font.family: Appearance.font.family.expressive
                    font.pixelSize: Appearance.font.pixelSize.hugeass
                    color: Appearance.colors.colOnLayer0
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }
                StyledText {
                    Layout.fillWidth: true
                    visible: text.length > 0
                    text: root.hero?.trackArtist ?? ""
                    font.pixelSize: Appearance.font.pixelSize.normal
                    color: Appearance.m3colors.m3onSurfaceVariant
                    elide: Text.ElideRight
                }
            }

            RowLayout {
                spacing: 8
                TimeLabel {
                    text: StringUtils.friendlyTimeForSeconds(root.hero?.position ?? 0)
                }
                TrackProgress {
                    Layout.fillWidth: true
                    player: root.hero
                    highlightColor: root.accent
                    handleColor: root.accent
                    trackColor: root.tint.colSecondaryContainer
                }
                TimeLabel {
                    text: StringUtils.friendlyTimeForSeconds(root.hero?.length ?? 0)
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 24
                SkipButton {
                    iconName: "skip_previous"
                    enabled: root.hero?.canGoPrevious ?? false
                    onClicked: root.hero.previous()
                }
                RippleButton {
                    implicitWidth: 76
                    implicitHeight: 76
                    buttonRadius: Appearance.rounding.full
                    enabled: root.hero?.canTogglePlaying ?? false
                    colRipple: root.tint.colPrimaryActive
                    onClicked: root.hero.togglePlaying()
                    MaterialShape {
                        z: -1
                        anchors.fill: parent
                        shape: root.playing ? MaterialShape.Shape.Cookie9Sided : MaterialShape.Shape.Circle
                        color: root.accent
                    }
                    contentItem: MaterialSymbol {
                        text: root.playing ? "pause" : "play_arrow"
                        fill: 1
                        iconSize: 34
                        horizontalAlignment: Text.AlignHCenter
                        color: Appearance.m3colors.m3onPrimary
                    }
                }
                SkipButton {
                    iconName: "skip_next"
                    enabled: root.hero?.canGoNext ?? false
                    onClicked: root.hero.next()
                }
            }
        }
    }
}
