<!DOCTYPE html>

<html lang="en">
<body>
WebSocket connection: <input type="button" value="Connect" onclick="connect()" width="10px"> <input type="button" value="Disconnect" onclick="disconnect()" width="10px"> <br/>
What is your name? <input id="name" type="text"> <input type="button" value="Send" width="10px"> <br/>
Greetings <br/>
<span id="greetings"></span>

<script src="jquery-3.3.1.js" type="text/javascript"></script>
<script>
    //使用SockJS和stomp.js来打开“gs-guide-websocket”地址的连接，这也是我们使用Spring构建的SockJS服务。
    function connect() {
        var socket = new SockJS('/gs-guide-websocket');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function (frame) {
            //连接成功后的回调方法
            setConnected(true);
            console.log('Connected: ' + frame);
            //订阅/topic/greetings地址，当服务端向此地址发送消息时，客户端即可收到。
            stompClient.subscribe('/topic/greetings', function (greeting) {
                //收到消息时的回调方法，展示欢迎信息。
                showGreeting(JSON.parse(greeting.body).content);
            });
        });
    }

    function  showGreeting(content) {
        $('#greetings').text(content);
    }

    //断开连接的方法
    function disconnect() {
        if (stompClient !== null) {
            stompClient.disconnect();
        }
        setConnected(false);
        console.log("Disconnected");
    }
    //将用户输入的名字信息,使用STOMP客户端发送到“/app/hello”地址。它正是我们在GreetingController中定义的greeting()方法所处理的地址.
    function sendName() {
        stompClient.send("/app/hello", {}, JSON.stringify({'name': $("#name").val()}));
    }

</script>
</body>
</html>