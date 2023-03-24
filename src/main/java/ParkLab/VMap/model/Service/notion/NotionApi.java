package ParkLab.VMap.model.Service.notion;

import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;


/**
 * 노션 HTTP 전송 클래스
 */

@Service
public class NotionApi {
    private final RestTemplate restTemplate = new RestTemplate();
    // Notion API Key를 설정합니다.
    private final String apiKey = "secret_EYZ88tYVWhnppaa5HuPOA8rwpW3xRlrSOWgAvM2faNo";

    // Database ID를 설정합니다.
    private final String databaseId = "998ba0454f464716b72cdc88001e3f3c";


    public void postToNotion(String JsonContentBlock) throws Exception {
        // 요청 URL을 설정합니다.
        String url = "https://api.notion.com/v1/pages/";

        String json = "{\n" +
                "  \"parent\": {\n" +
                "    \"database_id\": \""+databaseId+ "\"\n" +
                "  },\n" +
                "  \"properties\": {\n" +
                "    \"회의자\": {\n" +
                "      \"select\": {\n" +
                "        \"name\": \"임재경.이세희.조원희.이상현\"\n" +
                "      }\n" +
                "    },\n" +
                "    \"회의\": {\n" +
                "      \"title\": [\n" +
                "        {\n" +
                "          \"text\": {\n" +
                "            \"content\": \"제 5차 프로젝트 회의 \"\n" +
                "          }\n" +
                "        }\n" +
                "      ]\n" +
                "    },\n" +
                "    \"회의 날짜\": {\n" +
                "      \"type\": \"rich_text\",\n" +
                "      \"rich_text\": [\n" +
                "        {\n" +
                "          \"text\": {\n" +
                "            \"content\": \"3월 25일 (토요일)\"\n" +
                "          }\n" +
                "        }\n" +
                "      ]\n" +
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
        ResponseEntity<String> responseEntity = restTemplate.exchange(url, HttpMethod.POST, requestEntity, String.class);

        // HTTP 응답 결과를 확인합니다.
        if (responseEntity.getStatusCode() == HttpStatus.OK) {
            System.out.println("블록 작성 성공!");
        } else {
            System.out.println("블록 작성 실패!");
        }
    }
}
