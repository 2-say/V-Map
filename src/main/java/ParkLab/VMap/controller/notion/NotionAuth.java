package ParkLab.VMap.controller.notion;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class NotionAuth {
    private static final String callBackUrl = "http://localhost:32929/notionApiTest";//The url defined in WSO2
    private static final String clientId = "1f2cddb1-eabf-4cd8-84c5-e3246fd27664";//clientId
    private static final String authorizeUrl = "https://api.notion.com/v1/oauth/authorize";

    private static String getAuthGrantType(String callbackURL) {
        return authorizeUrl + "?response_type=code&client_id=" + clientId + "&redirect_uri=" + callbackURL;
    }

    @GetMapping("/notionAuth")
    public static String Test() {
        NotionAuth notionAuth = new NotionAuth();
        String authGrantType = getAuthGrantType(callBackUrl);
        return "redirect:" + authGrantType;
    }
}
