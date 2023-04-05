package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.notion.TokenRequester;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class NotionAuthController {
    private static final String callBackUrl = "http://localhost:32929/notionApiTest";//The url defined in WSO2
    private static final String clientId = "1f2cddb1-eabf-4cd8-84c5-e3246fd27664";//clientId
    private static final String authorizeUrl = "https://api.notion.com/v1/oauth/authorize";
    private static final String clientPw = "secret_jyGm94IqHfPKHuRSai5ubsJjrNpn8H9Eaox0Tzyer4L";//clientPw

    private static String getAuthGrantType(String callbackURL) {
        return authorizeUrl + "?response_type=code&client_id=" + clientId + "&redirect_uri=" + callbackURL;
    }

    @GetMapping("/notionAuth")
    public static String Test() {
        String authGrantType = getAuthGrantType(callBackUrl);
        return "redirect:" + authGrantType;
    }

    @GetMapping("/notionApiTest")
    public String handleCallback(@RequestParam("code") String code) {
        // Do something with the code
        System.out.println("Authorization Code: " + code);

        TokenRequester requester = new TokenRequester(clientId, clientPw);
        requester.addParameter("grant_type", "authorization_code");
        requester.addParameter("code", code);
        requester.addParameter("redirect_uri", "http://localhost:32929/notionApiTest");

        String response = requester.requestToken("https://api.notion.com/v1/oauth/token");

        System.out.println(response);

        // Redirect to another page
        return "redirect:/success";
    }

    @GetMapping("/success")
    public static void test() {
    }
}
