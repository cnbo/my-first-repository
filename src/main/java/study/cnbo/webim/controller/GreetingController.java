package study.cnbo.webim.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.HtmlUtils;
import study.cnbo.webim.entity.Greeting;
import study.cnbo.webim.entity.HelloMessage;

@Controller
public class GreetingController {

    @GetMapping("/index")
    public ModelAndView toIndex() {
        return new ModelAndView("index");
    }

    @MessageMapping("/hello") // 使用 MessageMapping 注解来标识所有发送到 "/hello" 这个 destination 的消息，都会被路由到这个方法进行处理
    @SendTo("/topic/greetings") // 使用 SendTo 注解类标识这个方法返回的结果，都会被发送到它指定的 destination， "/topic/greetings"
    // 传入的参数 HelloMessage 为客户端发送过来的消息，是自动绑定的
    public Greeting greeting(HelloMessage message) throws InterruptedException {
        Thread.sleep(1000);
        return new Greeting("Hello, " + HtmlUtils.htmlEscape(message.getName()) + "!");
    }

}
