import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.services
import QtQuick
import QtQuick.Layouts

/** A neutral list of players; the hero is the one row opened up on its cover's colors. */
Item {
    id: root
    property var hero: null
    property var rest: []
    property bool appIcons: true
    readonly property bool playing: root.hero?.isPlaying ?? false
    readonly property QtObject tint: coverTint.scheme
    signal picked(var player)

    implicitWidth: Appearance.sizes.mediaControlsWidth
    implicitHeight: surface.implicitHeight + Appearance.sizes.elevationMargin * 2

    CoverTint {
        id: coverTint
        player: root.hero
    }

    component SkipButton: RippleButton {
        property string iconName
        implicitWidth: 36
        implicitHeight: 36
        buttonRadius: Appearance.rounding.full
        colBackgroundHover: root.tint.colSecondaryContainerHover
        colRipple: root.tint.colSecondaryContainerActive
        contentItem: MaterialSymbol {
            text: parent.iconName
            fill: 1
            iconSize: Appearance.font.pixelSize.huge
            horizontalAlignment: Text.AlignHCenter
            color: root.tint.colOnLayer0
        }
    }

    component Byline: RowLayout {
        id: byline
        property var player
        property color color
        Layout.fillWidth: true
        spacing: 6
        PlayerAppIcon {
            visible: root.appIcons
            player: byline.player
            implicitSize: 12
        }
        StyledText {
            Layout.fillWidth: true
            text: root.appIcons ? (byline.player?.trackArtist || byline.player?.identity || "")
                : [byline.player?.trackArtist, byline.player?.identity].filter(s => s).join(" · ")
            font.pixelSize: Appearance.font.pixelSize.smaller
            color: byline.color
            elide: Text.ElideRight
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
        implicitHeight: root.hero ? content.implicitHeight + 16 : 200
        radius: Appearance.rounding.screenRounding - Appearance.sizes.hyprlandGapsOut + 1
        color: Appearance.colors.colLayer0

        PagePlaceholder {
            shown: !root.hero
            icon: "music_off"
            title: Translation.tr("Nothing playing")
            description: Translation.tr("Media from any app shows up here")
            shape: MaterialShape.Shape.Cookie7Sided
            descriptionHorizontalAlignment: Text.AlignHCenter
        }

        ColumnLayout {
            id: content
            visible: !!root.hero
            x: 8
            y: 8
            width: parent.width - 16
            spacing: 2

            Backdrop {
                Layout.fillWidth: true
                implicitHeight: heroContent.implicitHeight + 28
                radius: Appearance.rounding.large
                player: root.hero
                tint: root.tint

                ColumnLayout {
                    id: heroContent
                    x: 14
                    y: 14
                    width: parent.width - 28
                    spacing: 8

                    RowLayout {
                        spacing: 14
                        PlayerArt {
                            player: root.hero
                            size: 72
                            radius: Appearance.rounding.verysmall
                            colFallback: root.tint.colSecondaryContainer
                            colOnFallback: root.tint.colOnSecondaryContainer
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            StyledText {
                                Layout.fillWidth: true
                                text: StringUtils.cleanMusicTitle(root.hero?.trackTitle) || Translation.tr("Untitled")
                                font.pixelSize: Appearance.font.pixelSize.large
                                color: root.tint.colOnLayer0
                                elide: Text.ElideRight
                            }
                            Byline {
                                player: root.hero
                                color: root.tint.colSubtext
                            }
                        }
                        RippleButton {
                            implicitWidth: 48
                            implicitHeight: 48
                            enabled: root.hero?.canTogglePlaying ?? false
                            buttonRadius: root.playing ? Appearance.rounding.normal : Appearance.rounding.full
                            colBackground: root.playing ? root.tint.colPrimary : root.tint.colSecondaryContainer
                            colBackgroundHover: root.playing ? root.tint.colPrimaryHover : root.tint.colSecondaryContainerHover
                            colRipple: root.playing ? root.tint.colPrimaryActive : root.tint.colSecondaryContainerActive
                            downAction: () => root.hero.togglePlaying()
                            contentItem: MaterialSymbol {
                                text: root.playing ? "pause" : "play_arrow"
                                fill: 1
                                iconSize: Appearance.font.pixelSize.huge
                                horizontalAlignment: Text.AlignHCenter
                                color: root.playing ? root.tint.colOnPrimary : root.tint.colOnSecondaryContainer
                            }
                        }
                    }

                    RowLayout {
                        spacing: 6
                        SkipButton {
                            iconName: "skip_previous"
                            enabled: root.hero?.canGoPrevious ?? false
                            downAction: () => root.hero.previous()
                        }
                        StyledText {
                            text: StringUtils.friendlyTimeForSeconds(root.hero?.position ?? 0)
                            font.pixelSize: Appearance.font.pixelSize.smaller
                            font.features: { "tnum": 1 }
                            color: root.tint.colSubtext
                        }
                        TrackProgress {
                            Layout.fillWidth: true
                            player: root.hero
                            highlightColor: root.tint.colPrimary
                            handleColor: root.tint.colPrimary
                            trackColor: root.tint.colSecondaryContainer
                        }
                        StyledText {
                            text: StringUtils.friendlyTimeForSeconds(root.hero?.length ?? 0)
                            font.pixelSize: Appearance.font.pixelSize.smaller
                            font.features: { "tnum": 1 }
                            color: root.tint.colSubtext
                        }
                        SkipButton {
                            iconName: "skip_next"
                            enabled: root.hero?.canGoNext ?? false
                            downAction: () => root.hero.next()
                        }
                    }
                }
            }

            Repeater {
                model: root.rest
                delegate: RippleButton {
                    id: row
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: 60
                    buttonRadius: Appearance.rounding.normal
                    colBackgroundHover: Appearance.colors.colLayer0Hover
                    colRipple: Appearance.colors.colLayer0Active
                    onClicked: root.picked(row.modelData)
                    contentItem: RowLayout {
                        spacing: 14
                        PlayerArt {
                            Layout.leftMargin: 6
                            player: row.modelData
                            size: 40
                            radius: Appearance.rounding.verysmall
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            StyledText {
                                Layout.fillWidth: true
                                text: StringUtils.cleanMusicTitle(row.modelData.trackTitle) || Translation.tr("Untitled")
                                font.pixelSize: Appearance.font.pixelSize.normal
                                color: Appearance.colors.colOnLayer0
                                elide: Text.ElideRight
                            }
                            Byline {
                                player: row.modelData
                                color: Appearance.colors.colSubtext
                            }
                        }
                        MaterialSymbol {
                            visible: row.modelData.isPlaying
                            text: "graphic_eq"
                            iconSize: Appearance.font.pixelSize.larger
                            color: Appearance.colors.colPrimary
                        }
                        RippleButton {
                            Layout.rightMargin: 10
                            implicitWidth: 40
                            implicitHeight: 40
                            buttonRadius: Appearance.rounding.full
                            enabled: row.modelData.canTogglePlaying ?? false
                            colBackgroundHover: Appearance.colors.colLayer1Hover
                            onClicked: row.modelData.togglePlaying()
                            contentItem: MaterialSymbol {
                                text: row.modelData.isPlaying ? "pause" : "play_arrow"
                                fill: 1
                                iconSize: Appearance.font.pixelSize.huge
                                horizontalAlignment: Text.AlignHCenter
                                color: Appearance.colors.colOnLayer0
                            }
                        }
                    }
                }
            }
        }
    }
}
