package ParkLab.VMap.model.Service.notion;

import ParkLab.VMap.controller.meeting.MeetingDataController;
import org.json.JSONObject;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;


/**
 * 노션 HTTP 전송 클래스
 */

@Service
public class NotionPatch {
    private final MeetingDataController meetingDataController = new MeetingDataController();
    private final RestTemplate restTemplate = new RestTemplate();
    NotionApi notionApi = new NotionApi();
    public void postToNotion(String JsonContentBlock, String apiKey, String databaseId) throws Exception {
        // 요청 URL을 설정합니다.
//        String title = meetingDataController.getMeetingData().getTitle();
        String title = "쎾쓰";
        String id = notionApi.getId();
        String url = "https://api.notion.com/v1/blocks/"+id+"/children/";

        String json = "{\n" +
                "   \"children\": [\n" +
                "      {\n" +
                "         \"object\": \"block\",\n" +
                "         \"type\": \"heading_2\",\n" +
                "         \"heading_2\": {\n" +
                "            \"rich_text\": [{ \"type\": \"text\", \"text\": { \"content\": \"텍스트 수정 내용\" } }]\n" +
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
        headers.set("Authorization", "Bearer " + apiKey);


        // HTTP 요청 데이터를 설정합니다.
        HttpEntity<String> requestEntity = new HttpEntity<>(json, headers);

        // HTTP POST 요청을 보냅니다.
        ResponseEntity<String> responseEntity = restTemplate.exchange(url, HttpMethod.PATCH, requestEntity, String.class);
        System.out.println("responseEntity = " + responseEntity);

        // HTTP 응답 결과를 확인합니다.
        if (responseEntity.getStatusCode() == HttpStatus.OK) {
            System.out.println("블록 작성 성공!");
        } else {
            System.out.println("블록 작성 실패!");
        }

        extractedNotionDatabaseId(responseEntity);
    }

    private String extractedNotionDatabaseId(ResponseEntity<String> responseEntity) {
        // ResponseEntity에서 JSON 추출
        JSONObject json = new JSONObject(responseEntity.getBody());

        // "id"값 추출
        String id = json.getString("id");

        // 결과 출력
        return id;
    }
}
