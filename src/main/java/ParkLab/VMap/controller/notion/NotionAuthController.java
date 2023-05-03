package ParkLab.VMap.controller.notion;
import ParkLab.VMap.model.Service.notion.NotionAuthServiceImp;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class NotionAuthController {
    private NotionAuthServiceImp notionAuthService;

    public NotionAuthController() {
        this.notionAuthService = new NotionAuthServiceImp();
    }
    //노션 인증 URL 생성
    @GetMapping("/notionAuth")
    public void handleNotionAuthRequest() {
        notionAuthService.Test();
    }

    @GetMapping("/notionApiTest")
    public void handleNotionAuthRequest1(@RequestParam("code") String code) throws JsonProcessingException {
        notionAuthService.handleCallback(code);
    }

    @GetMapping("/getData")
    public String find_database(@RequestParam("accessToken") String accessToken) {
        return notionAuthService.find_database(accessToken);
    }

}
