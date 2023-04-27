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
public class NotionApi {
    private MeetingDataController meetingDataController = new MeetingDataController();
    private final RestTemplate restTemplate = new RestTemplate();
    ResponseEntity<String> responseEntity;

    public void postToNotion(String JsonContentBlock,String apiKey, String databaseId) throws Exception {
        // 요청 URL을 설정합니다.
//        String title = meetingDataController.getMeetingData().getTitle();
        String title = "쎾쓰";
        String url = "https://api.notion.com/v1/pages/";

        String json = "{\n" +
                "  \"parent\": {\n" +
                "    \"database_id\": \""+databaseId+ "\"\n" +
                "  },\n" +
                "  \"properties\": {\n" +
                "    \"유형\": {\n" +
                "      \"select\": {\n" +
                "        \"name\": \"짧은 회의\"\n" +
                "      }\n" +
                "    },\n" +
                "    \"이름\": {\n" +
                "      \"title\": [\n" +
                "        {\n" +
                "          \"text\": {\n" +
                "            \"content\": \""+title+"\"\n" +
                "          }\n" +
                "        }\n" +
                "      ]\n" +
                "    },\n" +
                "    \"이벤트 시간\": {\n" +
                "      \"type\": \"date\",\n" +
                "      \"date\": {\n" +
                "          \"start\": \"2023-04-08\"\n  "+
                "      }\n" +
                "    }\n" +
                "  },\n" +
                "  \"children\": [\n" +
                JsonContentBlock +
                "  ]\n" +
                "}";

        // HTTP 요청 헤더를 설정합니다.
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Notion-Version", "2021-08-16");
        headers.set("Authorization", "Bearer " + apiKey);



        // HTTP 요청 데이터를 설정합니다.
        HttpEntity<String> requestEntity = new HttpEntity<>(json, headers);

        // HTTP POST 요청을 보냅니다.
        responseEntity = restTemplate.exchange(url, HttpMethod.POST, requestEntity, String.class);
        System.out.println("responseEntity = " + responseEntity);

        // HTTP 응답 결과를 확인합니다.
        if (responseEntity.getStatusCode() == HttpStatus.OK) {
            System.out.println("블록 작성 성공!");
        } else {
            System.out.println("블록 작성 실패!");
        }

        extractedNotionDatabaseId(responseEntity);
    }

    private void extractedNotionDatabaseId(ResponseEntity<String> responseEntity) {
        // ResponseEntity에서 JSON 추출
        JSONObject json = new JSONObject(responseEntity.getBody());

        // "id"값 추출
        String id = json.getString("id");

        MyDataSingleton.getInstance().setData(id);
    }
}




