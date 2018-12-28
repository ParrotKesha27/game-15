import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import "highscores.js" as HS

ApplicationWindow {
    id: window
    visible: true
    width: 600
    height: 700
    title: qsTr("Пятнашки")
    property var gameField: []
    property int count: 0

    header: Rectangle {
        id: rectangle
        height: 50
        width: parent.width
        color: "#a2a2a2"
        Label {
            id: moves
            anchors.left: parent.left
            text: qsTr("Ходов сделано: ")
            font.pointSize: 14
            font.weight: Font.Bold
            font.family: "Arial"
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            color: 'white'
        }
        Label {
            id: cnt
            anchors.left: moves.right
            text: parseInt(count)
            font.pointSize: 14
            font.weight: Font.Bold
            font.family: "Arial"
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            color: 'white'
        }
        Button {
            id: hgscButton
            height: 50
            text: qsTr("Таблица рекордов")
            font.pointSize: 10
            highlighted: false
            flat: false
            anchors.verticalCenterOffset: 0
            anchors.right: exitButton.left
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                hg.visible = true
            }

        }
        Button {
            id: exitButton
            height: 50
            text: qsTr("Новая игра")
            font.pointSize: 10
            highlighted: false
            flat: false
            anchors.verticalCenterOffset: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.verticalCenter: parent.verticalCenter
            onClicked: newGame()
        }
    }

    Window {
        id: hg
        title: qsTr("Таблица рекордов")
        height: 700
        width: 600
        visible: false
        ListView {
            id: hgscView
            height: parent.height
            width: parent.width
            model: ListModel {}
            delegate: scoreDelegate
        }

        Component.onCompleted: {
            HS.dbInit()
            HS.dbReadAll(hgscView.model)
        }
    }

    Component {
        id: scoreDelegate
        Text {
            text: name + " " + score
            font.pointSize: 14
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

    }

    Component {
        id: btn
        Button {
            height: gridview.cellHeight * 0.9
            width: gridview.cellWidth * 0.9
            text: myText
            visible: myVisible
            font.pointSize: 20
            onClicked: {
                var move = checkMove(index)
                if (move !== 0) {
                    var btn = gridview.model.get(index+move)
                    // меняем текст и видимость кнопок
                    myVisible = false
                    btn.myText = parseInt(text)
                    btn.myVisible = true
                    myText = 0
                    // меняем значения в списке
                    gameField[index+move] = gameField[index]
                    gameField[index] = 0
                    if (checkWin()) winGame.open() // если игра окончена, то выводим сообщение
                    count++ // увеличиваем число ходов
                }
            }
        }
    }

    function newGame() {
        var i, n
        if (gameField.length !== 0) {
            for (i = 0; i < 16; i++) {
                gameField.pop()
            }
        }

        gridview.model.clear()

        for (i = 0; i < 16; i++)
        {
                do {
                    n = Math.floor(Math.random() * 16)
                } while(gameField.indexOf(n) != -1)
                gameField.push(n)
                if (n !== 0)
                    gridview.model.append({
                                      myText: n, myVisible: true});
                else
                    gridview.model.append({
                                          myText: n, myVisible: false});
        }
        count = 0
    }

    MessageDialog {
        id: winGame
        title: 'Игра окончена'
        text: 'Победа, победа, вместо обеда! Вы закончили игру за ' + count.toString() + ' ходов'
        onAccepted: {
            HS.dbInsert("Player", count)
            newGame()
            hg.visible = true
        }

    }

    function checkMove(index) {
        if (gameField[index-1] === 0 && index % 4 !== 0)
            return -1
        if (gameField[index+1] === 0 && index % 4 !== 3)
            return 1
        if (gameField[index-4] === 0)
            return -4
        if (gameField[index+4] === 0)
            return 4
        return 0
    }

    function checkWin() {
        var i
        for (i = 0; i < 15; i++) {
            if (gameField[i] !== i+1)
                return false
        }
        return true
    }

    Component.onCompleted: {
        newGame()
    }

    GridView {
        id: gridview

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: 20
            topMargin: 20
        }

        cellHeight: height / 4
        cellWidth: width / 4

        model: ListModel { id: listButton }
        delegate: btn
    }
}

