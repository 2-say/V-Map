package ParkLab.VMap.model.Service.notion;

import ParkLab.VMap.model.Service.DecodeJson.DecordJsonService;
import ParkLab.VMap.model.Service.firebase.FirebaseMeetingsServiceImpl;
import ParkLab.VMap.model.data.ClerkInfo;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import okhttp3.*;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

public class NotionEditServiceImpl {
    FirebaseMeetingsServiceImpl firebaseMeetingsServiceImpl = new FirebaseMeetingsServiceImpl();
    private String contents;
    private String accessToken;
    private String pageId;
    private String extractedContents;
    private String time;

    public void updateNotionBlock(String blockId) {
        MediaType JSON = MediaType.parse("application/json; charset=utf-8");
        String NOTION_API_URL = "https://api.notion.com/v1/blocks/" + blockId;

        OkHttpClient client = new OkHttpClient();
        // 변수로 전달되는 값을 대체하여 JSON 객체 생성
        String content = extractedContents + " : " + contents;
        JSONObject jsonBody = new JSONObject();
        JSONObject richText = new JSONObject();
        richText.put("type", "text");
        richText.put("text", new JSONObject().put("content", content));
        jsonBody.put("paragraph", new JSONObject().put("rich_text", new JSONObject[]{richText}));

        RequestBody requestBody = RequestBody.create(JSON, jsonBody.toString());

        Request request = new Request.Builder()
                .url(NOTION_API_URL)
                .addHeader("Authorization", "Bearer " + accessToken)
                .addHeader("Content-Type", "application/json")
                .addHeader("Notion-Version", "2021-08-16")
                .patch(requestBody)
                .build();

        try {
            Response response = client.newCall(request).execute();
            if (response.isSuccessful()) {
                System.out.println("PATCH 요청이 성공적으로 전송되었습니다.");
            } else {
                System.out.println("PATCH 요청이 실패하였습니다. 응답 코드: " + response.code());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    public String retrieveNotionBlock() {

        //액세스 토큰
        //pageid-필요
        String notionVersion = "2021-08-16";

        String urlStr = "https://api.notion.com/v1/blocks/" + pageId + "/children";
        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            conn.setRequestProperty("Notion-Version", notionVersion);

            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String inputLine;
                StringBuilder response = new StringBuilder();
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();
                System.out.println(response.toString());

                Map<String,String> blockid = findIdAndContentByTime(response.toString());
                System.out.print(blockid);
                String content = blockid.get("content");
                String[] parts = content.split(" : ");
                extractedContents = parts[0];

                return blockid.get("id");



            } else {
//                System.out.println("Error - Response Code: " + responseCode);


            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }


    public Map<String, String> findIdAndContentByTime(String jsonString) {
        JsonParser parser = new JsonParser();
        JsonElement jsonElement = parser.parse(jsonString);

        // 전체 JSON에서 results 배열 가져오기
        JsonArray results = jsonElement.getAsJsonObject().getAsJsonArray("results");
        System.out.println("results = " + results);
        // results 배열을 순회하며 content 값이 주어진 시간인 경우 해당 id와 content 반환
        for (JsonElement resultElement : results) {
            JsonObject resultObject = resultElement.getAsJsonObject();
            String id = resultObject.get("id").getAsString();
            
            // content 값이 주어진 시간과 동일한 경우 id와 content 반환
            if (resultObject.has("paragraph")) {
                JsonObject paragraphObject = resultObject.getAsJsonObject("paragraph");
                JsonArray textArray = paragraphObject.getAsJsonArray("text");
                StringBuilder contentBuilder = new StringBuilder();
                for (JsonElement textElement : textArray) {
                    JsonObject textObject = textElement.getAsJsonObject();
                    String content = textObject.get("plain_text").getAsString();
                    contentBuilder.append(content);
                }
                String content = contentBuilder.toString();
                if (content.contains(time)) {
                    Map<String, String> result = new HashMap<>();
                    result.put("id", id);
                    result.put("content", content);
                    return result;
                }
            }
        }

        return null; // 해당 시간을 찾지 못한 경우 null 반환
    }

    public void setDocumentId(String documentId, String requestBody) throws Exception {
        System.out.println("documentId = " + documentId);
        ClerkInfo clerkInfo = firebaseMeetingsServiceImpl.getClerkInfo(documentId);

        DecordJsonService decodeJsonService = new DecordJsonService(requestBody);

        String contents = decodeJsonService.getContents();
        String time = decodeJsonService.getTime();

        System.out.println("contents = " + contents);
        System.out.println("time = " + time);
        
        this.contents = contents;

        this.accessToken = clerkInfo.getAccessToken();
        this.pageId = clerkInfo.getPageId();
        this.time = time;

        System.out.println("accessToken = " + accessToken);
        System.out.println("pageId = " + pageId);

        updateNotionBlock(retrieveNotionBlock());
    }
}
