pragma ComponentBehavior: Bound

import qs.components
import qs.components.controls
import qs.components.effects
import qs.services
import qs.config
import Caelestia
import QtQuick
import QtQuick.Layouts

Loader {
    id: root

    required property var props

    anchors.fill: parent

    opacity: root.props.recordingConfirmDelete ? 1 : 0
    active: opacity > 0
    asynchronous: true

    sourceComponent: MouseArea {
        id: deleteConfirmation

        property string path

        Component.onCompleted: path = root.props.recordingConfirmDelete

        hoverEnabled: true
        onClicked: root.props.recordingConfirmDelete = ""

        StyledRect {
            anchors.centerIn: parent
            radius: Appearance.rounding.large
            color: Colours.palette.m3surfaceContainerHigh

            scale: 0.5
            Component.onCompleted: scale = Qt.binding(() => root.props.recordingConfirmDelete ? 1 : 0.5)

            width: Math.min(parent.width - Appearance.padding.large * 2, implicitWidth)
            implicitWidth: deleteConfirmationLayout.implicitWidth + Appearance.padding.large * 3
            implicitHeight: deleteConfirmationLayout.implicitHeight + Appearance.padding.large * 3

            Elevation {
                anchors.fill: parent
                radius: parent.radius
                z: -1
                level: 3
            }

            ColumnLayout {
                id: deleteConfirmationLayout

                anchors.fill: parent
                anchors.margins: Appearance.padding.large * 1.5
                spacing: Appearance.spacing.normal

                StyledText {
                    text: qsTr("Delete recording?")
                    font.pointSize: Appearance.font.size.large
                }

                StyledText {
                    Layout.fillWidth: true
                    text: qsTr("Recording '%1' will be permanently deleted.").arg(deleteConfirmation.path)
                    color: Colours.palette.m3onSurfaceVariant
                    font.pointSize: Appearance.font.size.small
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }

                RowLayout {
                    Layout.topMargin: Appearance.spacing.normal
                    Layout.alignment: Qt.AlignRight
                    spacing: Appearance.spacing.normal

                    TextButton {
                        text: qsTr("Cancel")
                        type: TextButton.Text
                        label.color: Colours.palette.m3primary
                        stateLayer.color: Colours.palette.m3primary

                        function onClicked(): void {
                            root.props.recordingConfirmDelete = "";
                        }
                    }

                    TextButton {
                        text: qsTr("Delete")
                        type: TextButton.Text
                        label.color: Colours.palette.m3primary
                        stateLayer.color: Colours.palette.m3primary

                        function onClicked(): void {
                            CUtils.deleteFile(Qt.resolvedUrl(root.props.recordingConfirmDelete));
                            root.props.recordingConfirmDelete = "";
                        }
                    }
                }
            }

            Behavior on scale {
                Anim {
                    duration: Appearance.anim.durations.expressiveDefaultSpatial
                    easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
                }
            }
        }
    }

    Behavior on opacity {
        Anim {}
    }
}
