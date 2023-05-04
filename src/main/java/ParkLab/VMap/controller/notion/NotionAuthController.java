package ParkLab.VMap.controller.notion;
import ParkLab.VMap.model.Service.notion.NotionAuthServiceImpl;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class NotionAuthController {
    private NotionAuthServiceImpl notionAuthServiceImpl;

    public NotionAuthController() {
        this.notionAuthServiceImpl = new NotionAuthServiceImpl();
    }
    //노션 인증 URL 생성
    @GetMapping("/notionAuth")
    public void handleNotionAuthRequest() {
        notionAuthServiceImpl.Test();
    }

    @GetMapping("/notionApiTest")
    public void handleNotionAuthRequest1(@RequestParam("code") String code) throws JsonProcessingException {
        notionAuthServiceImpl.handleCallback(code);
    }

    @GetMapping("/getData")
    public String find_database(@RequestParam("accessToken") String accessToken) {
        return notionAuthServiceImpl.find_database(accessToken);
    }
}
