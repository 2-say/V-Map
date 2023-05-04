package ParkLab.VMap.model.Service.notion;

import ParkLab.VMap.controller.meeting.MeetingDataController;
import ParkLab.VMap.model.Service.DecodeJson.DecordJsonService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 노션 HTTP 전송 클래스
 */

@Service
public class NotionApi {
    private MeetingDataController meetingDataController = new MeetingDataController();
    private final RestTemplate restTemplate = new RestTemplate();
    ResponseEntity<String> responseEntity;

    public String postToNotion(String JsonContentBlock, String requestBody) throws Exception {
        // 요청 URL을 설정합니다.
        String url = "https://api.notion.com/v1/pages/";

        DecordJsonService decodeJsonService = new DecordJsonService(requestBody);
        String meetingName = decodeJsonService.getMeetingName();
        List<String> meetingParticipants = decodeJsonService.getMeetingParticipants();
        String startTime = decodeJsonService.getStartTime();
        String accessToken = decodeJsonService.getAccessToken();
        String databaseId = decodeJsonService.getDatabaseId();

        String json = "{\n" +
                "  \"parent\": {\n" +
                "    \"database_id\": \""+databaseId+ "\"\n" +
                "  },\n" +
                "  \"properties\": {\n" +
                "    \"유형\": {\n" +
                "      \"select\": {\n" +
                "        \"name\": \""+meetingParticipants+"\"\n" +
                "      }\n" +
                "    },\n" +
                "    \"이름\": {\n" +
                "      \"title\": [\n" +
                "        {\n" +
                "          \"text\": {\n" +
                "            \"content\": \""+meetingName+"\"\n" +
                "          }\n" +
                "        }\n" +
                "      ]\n" +
                "    },\n" +
                "    \"이벤트 시간\": {\n" +
                "      \"type\": \"date\",\n" +
                "      \"date\": {\n" +
                "          \"start\": \""+startTime+"\"\n  "+
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
        headers.set("Authorization", "Bearer " + accessToken);



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

        JSONObject jsonForPageId = new JSONObject(responseEntity.getBody());
        String pageId = jsonForPageId.getString("id");

        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, String> responseMap = new HashMap<>();
            responseMap.put("pageId", pageId);
            return objectMapper.writeValueAsString(responseMap);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return "failed";
    }
}




