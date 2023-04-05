package ParkLab.VMap.model.Service.notion;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

public class FindData {

    private static final String NOTION_API_ENDPOINT = "https://api.notion.com/v1/search";
    private static final String DATABASE_ID = "89345119-203e-4c31-b025-0c22740eb46c";
    private static final String AUTHORIZATION_HEADER_VALUE = "secret_Tozo3hAhvU84OLjGEwl2nOHR12Oyiusb8PJThyw1yBm";
    private static final String NOTION_VERSION = "2021-08-16"; // Replace with your desired version

    public String find_database() {
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", AUTHORIZATION_HEADER_VALUE);
        headers.set("Notion-Version", NOTION_VERSION); // Add Notion version to headers

        HttpEntity<String> requestEntity = new HttpEntity<>("{}", headers);
        ResponseEntity<String> responseEntity = restTemplate.exchange(NOTION_API_ENDPOINT, HttpMethod.POST, requestEntity, String.class);
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
                    return databaseId;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "not found database id";
    }
}

