package ParkLab.VMap.controller.notion;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
public class NotionApiTest {
    @GetMapping("/success")
    public static String test() {
        return "Success!";
    }

    private static final String clientId = "1f2cddb1-eabf-4cd8-84c5-e3246fd27664";//clientId
    private static final String clientPw = "secret_jyGm94IqHfPKHuRSai5ubsJjrNpn8H9Eaox0Tzyer4L";//clientId
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

}
