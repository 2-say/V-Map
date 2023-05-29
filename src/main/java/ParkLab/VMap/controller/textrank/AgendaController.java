package ParkLab.VMap.controller.textrank;

import ParkLab.VMap.model.Service.EncodeJson.EncodeJsonService;
import ParkLab.VMap.model.Service.firebase.FirebaseMeetingsServiceImpl;
import ParkLab.VMap.model.data.ClerkInfo;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.bind.annotation.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.List;

@RestController
@CrossOrigin(origins = "*")
public class AgendaController {
    FirebaseMeetingsServiceImpl firebaseMeetingsService = new FirebaseMeetingsServiceImpl();
    EncodeJsonService encodeJsonService = new EncodeJsonService();
    private String accessToken;
    private String pageId;
    @GetMapping("/agenda")
    @ResponseBody
    public void agenda(@RequestParam("documentId") String documentId, @RequestParam ("pageId") String pageId){
        String apiUrl = "http://127.0.0.1:5000/agenda?pageId=" + pageId;

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(apiUrl))
                .GET()
                .build();
        try {
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            System.out.println("Status code: " + response.statusCode());
            System.out.println("Response body: " + response.body());

            List<String> agendaList = encodeJsonService.convertToList(response.body());
            firebaseMeetingsService.updateFirebaseMeetingAgenda(documentId, agendaList);
            ClerkInfo clerkInfo = firebaseMeetingsService.getClerkInfo(documentId);
            this.accessToken = clerkInfo.getAccessToken();
            this.pageId = pageId;
            updateAgenda(agendaList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateAgenda(List<String> agendaString) throws IOException {
        List<String> reversedList = new ArrayList<>();  //pop하기 위해서 꺼꾸로 꺼냄
        for (int i = agendaString.size() - 1; i >= 0; i--) {
            reversedList.add(agendaString.get(i));
        }


        StringBuilder response = new StringBuilder();
        String notionVersion = "2021-08-16";
        String urlStr = "https://api.notion.com/v1/blocks/" + pageId + "/children";
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        conn.setRequestProperty("Notion-Version", notionVersion);
        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
        }

        List<String> blockIdList = new ArrayList<>();

        JSONObject data = new JSONObject(response.toString());
        String formattedJsonString = data.toString(4);
        JSONObject data1 = new JSONObject(formattedJsonString);
        JSONArray results = data1.getJSONArray("results");
        System.out.printf("전달받은 안건의 개수",results.length());


        for (int i = 0; i < results.length(); i++) {   //찾아서 넣기
            JSONObject blockObject = results.getJSONObject(i);
            if (blockObject.getString("type").equals("numbered_list_item")) {
                String blockId = blockObject.getString("id");
                System.out.println("Numbered List Item ID: " + blockId);
                blockIdList.add(blockId);
            }
        }

        for (String blockId : blockIdList) {

            if (!reversedList.isEmpty()) {
                String poppedElement = reversedList.remove(reversedList.size() - 1);
                System.out.println("꺼낸 원소: " + poppedElement);


                String json = "{\n" +
                        "    \"type\": \"numbered_list_item\",\n" +
                        "    \"numbered_list_item\": {\n" +
                        "        \"rich_text\": [\n" +
                        "            {\n" +
                        "                \"type\": \"text\",\n" +
                        "                \"text\": {\n" +
                        "                    \"content\": \"" + poppedElement + " \"\n" +
                        "                }\n" +
                        "            }\n" +
                        "        ]\n" +
                        "    }\n" +
                        "}";


                MediaType JSON = MediaType.parse("application/json; charset=utf-8");
                String NOTION_API_URL = "https://api.notion.com/v1/blocks/" + blockId;

                OkHttpClient client = new OkHttpClient();

                okhttp3.RequestBody requestBody = okhttp3.RequestBody.create(JSON, json);

                Request request = new Request.Builder()
                        .url(NOTION_API_URL)
                        .addHeader("Authorization", "Bearer " + accessToken)
                        .addHeader("Content-Type", "application/json")
                        .addHeader("Notion-Version", "2021-08-16")
                        .patch(requestBody)
                        .build();

                try {
                    Response response1 = client.newCall(request).execute();
                    if (response1.isSuccessful()) {
                        System.out.println("PATCH 요청이 성공적으로 전송되었습니다.");
                    } else {
                        System.out.println("PATCH 요청이 실패하였습니다. 응답 코드: " + response1.toString());
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }

            }

        }

    }


}
