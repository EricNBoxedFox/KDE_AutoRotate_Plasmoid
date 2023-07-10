/*
    GPL-2.0-or-later
    Written by Eric Nielsen
 */
import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.kquickcontrolsaddons 2.0

Item {
    id: root
//     Setting the globals
    property bool stdout: true

    PlasmaCore.DataSource {
        id: getStateExecute
        engine: "executable"
        connectedSources: []
        onNewData: {
//             Storing all the status's and the output, uncomment the dragon here and use it for an if condition in the future if there are issues.
            // var exitCode = data["exit code"]  /*Exit code dragon*/
            // var exitStatus = data["exit status"] /*Exit Status dragon Use these drangons for IF conditions in the future*/
            stdout = data["stdout"]
            // var stderr = data["stderr"]
//             Retaining these for testing. May need to add conditions for errors on task run. But Im too lazy to do it now unless I run into an issue.
            // console.log(exitCode)
            // console.log(exitStatus)
            // console.log(stdout[0])
            // console.log(stderr)
            disconnectSource(sourceName)
        }

        function run(command) {
            getStateExecute.connectSource(command)
        }
    }




    PlasmaCore.DataSource {
        id: updateStateExecute
        engine: "executable"
        connectedSources: []
        onNewData: {
//             Just here to keep this seperate from the get status piece. Prevents it from writing to the stdout
            disconnectSource(sourceName)
        }

        function run(command) {
            getStateExecute.connectSource(command)
        }
    }




    Button {
        id: button
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        // text: stdout
        Image {
            source: stdout ? "rotateDisabled.svg" : "rotateEnabled.svg"
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }



        onClicked: {
//             Retrieving the current rotation status. Grab this every time in case it changed from something externally
            getRotationStatus()

//             based on the current auto rotate status either run one way or the other
            if (stdout) {
                updateStateExecute.run(plasmoid.configuration.disableAuto)

                // console.log("True")
                stdout = false

            }
            else {
                updateStateExecute.run(plasmoid.configuration.enableAuto)

                // console.log("False")
                stdout = true
            }

        }


        Component.onCompleted: {
            getRotationStatus()
        }
    }

    function getRotationStatus() {
        getStateExecute.run(plasmoid.configuration.getState)
        // console.log(execute.active)
    }
}
