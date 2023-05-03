package ParkLab.VMap.model.Service.notion;

import ParkLab.VMap.model.Service.DecodeJson.DecordJsonService;
import org.springframework.http.*;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class NotionPatchServiceImp {
    private final RestTemplate restTemplate = new RestTemplate();


    public void patchToNotion(String requestBody) throws Exception {

        DecordJsonService decodeJsonService = new DecordJsonService(requestBody);


        String contents = decodeJsonService.getContents();
        String accessToken = decodeJsonService.getAccessToken();
        String user = decodeJsonService.getUser();
        String time = decodeJsonService.getTime();
        String pageId = decodeJsonService.getPageId();

        String url = "https://api.notion.com/v1/blocks/"+pageId+"/children/";
        String json = "{\n" +
                "   \"children\": [\n" +
                "      {\n" +
                "         \"object\": \"block\",\n" +
                "         \"type\": \"heading_2\",\n" +
                "         \"heading_2\": {\n" +
                "            \"rich_text\": [{ \"type\": \"text\", \"text\": { \"content\": \"["+time+"] "+user+" : "+contents+"\" } }]\n" +
                "         }\n" +
                "      },\n" +
                "      {\n" +
                "         \"object\": \"block\",\n" +
                "         \"type\": \"paragraph\",\n" +
                "         \"paragraph\": {\n" +
                "            \"rich_text\": [\n" +
                "               {\n" +
                "                  \"type\": \"text\",\n" +
                "                  \"text\": {\n" +
                "                     \"content\": \"내용\",\n" +
                "                     \"link\": { \"url\": \"https://develop247.tistory.com/\" }\n" +
                "                  }\n" +
                "               }\n" +
                "            ]\n" +
                "         }\n" +
                "      }\n" +
                "   ]\n" +
                "}";

        // HTTP 요청 헤더를 설정합니다.
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Notion-Version", "2021-08-16");
        headers.set("Authorization", "Bearer " + accessToken);
        System.out.println("apiKey = " + accessToken);

        // HTTP 요청 데이터를 설정합니다.
        HttpEntity<String> requestEntity = new HttpEntity<>(json, headers);

        // Http PATCH method 사용 위해 RequestFactory를 세팅한다.
        restTemplate.setRequestFactory(new HttpComponentsClientHttpRequestFactory());

        // HTTP POST 요청을 보냅니다.
        ResponseEntity<String> responseEntity = restTemplate.exchange(url, HttpMethod.PATCH, requestEntity, String.class);
        System.out.println("responseEntity = " + responseEntity);

        // HTTP 응답 결과를 확인합니다.
        if (responseEntity.getStatusCode() == HttpStatus.OK) {
            System.out.println("블록 작성 성공!");
        } else {
            System.out.println("블록 작성 실패!");
        }
    }
}
