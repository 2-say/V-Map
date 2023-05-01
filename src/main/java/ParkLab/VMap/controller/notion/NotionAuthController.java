package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.notion.MyDataSingleton;
import ParkLab.VMap.model.Service.notion.TokenRequester;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Controller
public class NotionAuthController {

    // for server
//    private static final String callBackUrl = "http://218.150.182.202:32929/notionApiTest";//The url defined in WSO2

    // for local
    private static final String callBackUrl = "https://localhost:32929/notionApiTest";//The url defined in WSO2
    private static final String clientId = "d088e98c-ab3c-49ad-b671-1850687ff05b";//clientId
    private static final String authorizeUrl = "https://api.notion.com/v1/oauth/authorize";
    private static final String clientPw = "secret_WAd029yDKxesEd30bHOQR7GU7WwbswJdPvr72yG9zdh";//clientPw

    private static String getAuthGrantType(String callbackURL) {
        return authorizeUrl + "?response_type=code&client_id=" + clientId + "&redirect_uri=" + callbackURL;
    }
    

    //노션 인증 URL 생성
    @GetMapping("/notionAuth")
    public static String Test(){
        String authGrantType = getAuthGrantType(callBackUrl);
        return "redirect:" + authGrantType;
    }

    @GetMapping("/notionApiTest")
    public String handleCallback(@RequestParam("code") String code) throws JsonProcessingException {
        // Do something with the code
        System.out.println("Authorization Code: " + code);

        TokenRequester requester = new TokenRequester(clientId, clientPw);
        requester.addParameter("grant_type", "authorization_code");
        requester.addParameter("code", code);
        requester.addParameter("redirect_uri", callBackUrl);

        String response = requester.requestToken("https://api.notion.com/v1/oauth/token");

//        System.out.println(response);
        Map<String, Object> jsonMap = new ObjectMapper().readValue(response, new TypeReference<Map<String, Object>>() {});
        String accessToken = (String) jsonMap.get("access_token");


        System.out.println("Access Token: " + accessToken);
        MyDataSingleton.getInstance().setToken(accessToken);
        System.out.println("MyDataSingleton.getInstance().getToken() = " + MyDataSingleton.getInstance().getToken());

        // Redirect to another page
        return "redirect:/getData?accessToken=" +accessToken;
    }

    @GetMapping("/getData")
    public String find_database(@RequestParam("accessToken") String accessToken) {
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", accessToken);
        headers.set("Notion-Version", "2021-08-16"); // Add Notion version to headers

        HttpEntity<String> requestEntity = new HttpEntity<>("{}", headers);
        ResponseEntity<String> responseEntity = restTemplate.exchange("https://api.notion.com/v1/search", HttpMethod.POST, requestEntity, String.class);
        String responseBody = responseEntity.getBody();
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode rootNode = objectMapper.readTree(responseBody);
            JsonNode resultsNode = rootNode.path("results");
            for (JsonNode resultNode : resultsNode) {
                String objectType = resultNode.path("object").asText();
                if (objectType.equals("database")) {
                    String databaseId = resultNode.path("id").asText();
                    System.out.println("Database ID: " + databaseId);
                    MyDataSingleton.getInstance().setDatabaseId(databaseId);
                    System.out.println("MyDataSingleton.getInstance().getToken() = " + MyDataSingleton.getInstance().getToken());
                    return "index"; // 노션 권한 승인 후 돌아갈 페이지 수정 필요
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
