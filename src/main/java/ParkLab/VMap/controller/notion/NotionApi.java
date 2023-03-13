package ParkLab.VMap.controller.notion;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class NotionApi {
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    // Notion API Key를 설정합니다.
    private final String apiKey = "secret_EYZ88tYVWhnppaa5HuPOA8rwpW3xRlrSOWgAvM2faNo";

    // Database ID를 설정합니다.
    private final String databaseId = "998ba0454f464716b72cdc88001e3f3c";

    /**
     * 블록 안에 내용을 작성합니다.
     *
     * @param title 블록의 제목
     * @param content 블록의 내용
     */
    public void createBlock(String title, String content) throws Exception {
        // 요청 URL을 설정합니다.
        String url = "https://api.notion.com/v1/pages/";
        String type = "heading_2";


        // 요청 데이터 (JSON)를 설정합니다.
        String json= "{\n" +
                "  \"parent\": {\n" +
                "    \"database_id\": \"998ba045-4f46-4716-b72c-dc88001e3f3c\"\n" +
                "  },\n" +
                "  \"properties\": {\n" +
                "    \"색상\": {\n" +
                "      \"select\": {\n" +
                "        \"name\": \"red\"\n" +
                "      }\n" +
                "    },\n" +
                "    \"이름\": {\n" +
                "      \"title\": [\n" +
                "        {\n" +
                "          \"text\": {\n" +
                "            \"content\": \"테스트 내용1 \"\n" +
                "          }\n" +
                "        }\n" +
                "      ]\n" +
                "    },\n" +
                "    \"맛\": {\n" +
                "      \"type\": \"rich_text\",\n" +
                "      \"rich_text\": [\n" +
                "        {\n" +
                "          \"text\": {\n" +
                "            \"content\": \"test1\"\n" +
                "          }\n" +
                "        }\n" +
                "      ]\n" +
                "    }\n" +
                "  },\n" +
                "  \"children\": [\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \""  + type + "\",\n" +
                "      \"" + type + "\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"" + content + "\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    }\n" +
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
