import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
ApplicationWindow {
    visible: true
    width: 640
    height: 480
    id:window
    title: qsTr("Hello World")
    property var  quest: ""
    property var ans: ""
    function pushData(q,a)//push数据
    {
        var request=new XMLHttpRequest();
        request.onreadystatechange=function()
        {
            if(request.readyState==request.DONE)
            console.log("数据push成功");
        }
        request.open("GET","http://119.29.11.92/push.ashx?qu="+q+"&&an="+a+"");
        request.send()
    }
    Component.onCompleted: {
        var request=new XMLHttpRequest();
        request.onreadystatechange=function()
        {
            if(request.readyState==request.DONE)
            {
                console.log(request.responseText);
                var oJson=JSON.parse(request.responseText);
                labquest.text="问题："+oJson.newslist[0].quest;
                window.quest=labquest.text
                window.ans=oJson.newslist[0].result;
                //push数据
                pushData(window.quest,window.ans);
            }
        }
        request.open("GET","http://api.tianapi.com/txapi/naowan/?key=ad20bfb0e908bab04dc9ef40f7dd87dd");
        request.send()
    }
    header: Pane
    {
        Material.elevation:10
        Text{
             text:"涵涵脑筋急转弯"
             anchors.centerIn: parent
        }
    }
    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page {
            Text{
                anchors.top:parent.top
                anchors.topMargin: 6
                  font.pixelSize: 30
               wrapMode: Text.Wrap
               width:window.width//指定宽度 wrapMode才有用
               id:labquest
               text:"问题："

            }
            Button{
                id:btnReload
                anchors.centerIn: parent

                text:"下一题"
                onClicked: {
                    btnReadAns.visible=true
                    var request=new XMLHttpRequest();
                    request.onreadystatechange=function()
                    {
                        if(request.readyState==request.DONE)
                        {
                            console.log(request.responseText);
                            var oJson=JSON.parse(request.responseText);
                            labquest.text="问题："+oJson.newslist[0].quest;
                            window.quest=labquest.text
                            window.ans=oJson.newslist[0].result;
                            //push数据
                            pushData(window.quest,window.ans);
                        }
                    }
                    request.open("GET","http://api.tianapi.com/txapi/naowan/?key=ad20bfb0e908bab04dc9ef40f7dd87dd");
                    request.send()
                }
            }
            Button{
              id:btnReadAns

              text:"查看答案"
              visible: true;
              onClicked: {
                labquest.text+="答案："+window.ans
                 btnReadAns.visible=false
              }
              anchors.top:labquest.bottom
            }
        }

        Page {
            Label {
                id:aboutlabel
                text: qsTr("作者：邱于涵\nQQ:1031893464\n")
                anchors.centerIn: parent
            }
            Button{
            text:"访问"
            anchors.top:aboutlabel.bottom;
            anchors.left:aboutlabel.left
            onClicked: Qt.openUrlExternally("https://blog.csdn.net/u012997311");
            }

        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("脑筋急转弯")
        }
        TabButton {
            text: qsTr("关于")
        }
    }
}
