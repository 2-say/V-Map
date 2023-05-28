package ParkLab.VMap.model.Service.notion;

import ParkLab.VMap.model.Service.DecodeJson.DecordJsonService;
import ParkLab.VMap.model.Service.firebase.FirebaseMeetingsServiceImpl;
import ParkLab.VMap.model.data.ClerkInfo;
import okhttp3.*;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;



public class NotionEditServiceImpl {
    FirebaseMeetingsServiceImpl firebaseMeetingsServiceImpl = new FirebaseMeetingsServiceImpl();
    private String contents;
    private String user;
    private String accessToken;
    private String pageId;
    private String extractedContents;
    private String time;

    public void deleteNotionBlock(String blockId) {
        String NOTION_API_URL = "https://api.notion.com/v1/blocks/" + blockId;

        OkHttpClient client = new OkHttpClient();

        Request request = new Request.Builder()
                .url(NOTION_API_URL)
                .addHeader("Authorization", "Bearer " + accessToken)
                .addHeader("Content-Type", "application/json")
                .addHeader("Notion-Version", "2021-08-16")
                .delete()
                .build();

        try {
            Response response = client.newCall(request).execute();
            if (response.isSuccessful()) {
                System.out.println("DELETE 요청이 성공적으로 전송되었습니다.");
            } else {
                System.out.println("DELETE 요청이 실패하였습니다. 응답 코드: " + response.code());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void updateNotionBlock(String blockId) {
        MediaType JSON = MediaType.parse("application/json; charset=utf-8");
        String NOTION_API_URL = "https://api.notion.com/v1/blocks/" + blockId;

        OkHttpClient client = new OkHttpClient();





        String json = "{\n" +
                "    \"callout\": {\n" +
                "        \"rich_text\": [\n" +
                "            {\n" +
                "                \"type\": \"text\",\n" +
                "                \"text\": {\n" +
                "                    \"content\": \"[\",\n" +
                "                    \"link\": null\n" +
                "                },\n" +
                "                \"annotations\": {\n" +
                "                    \"bold\": false,\n" +
                "                    \"italic\": false,\n" +
                "                    \"strikethrough\": false,\n" +
                "                    \"underline\": false,\n" +
                "                    \"code\": false,\n" +
                "                    \"color\": \"default\"\n" +
                "                },\n" +
                "                \"plain_text\": \"[\",\n" +
                "                \"href\": null\n" +
                "            },\n" +
                "            {\n" +
                "                \"type\": \"text\",\n" +
                "                \"text\": {\n" +
                "                    \"content\": \"  "  + this.time + "\",\n" +
                "                    \"link\": null\n" +
                "                },\n" +
                "                \"annotations\": {\n" +
                "                    \"bold\": false,\n" +
                "                    \"italic\": false,\n" +
                "                    \"strikethrough\": false,\n" +
                "                    \"underline\": false,\n" +
                "                    \"code\": false,\n" +
                "                    \"color\": \"orange_background\"\n" +
                "                },\n" +
                "                \"plain_text\": \"  " + this.time   + "\",\n" +
                "                \"href\": null\n" +
                "            },\n" +
                "            {\n" +
                "                \"type\": \"text\",\n" +
                "                \"text\": {\n" +
                "                    \"content\": \"] \",\n" +
                "                    \"link\": null\n" +
                "                },\n" +
                "                \"annotations\": {\n" +
                "                    \"bold\": false,\n" +
                "                    \"italic\": false,\n" +
                "                    \"strikethrough\": false,\n" +
                "                    \"underline\": false,\n" +
                "                    \"code\": false,\n" +
                "                    \"color\": \"default\"\n" +
                "                },\n" +
                "                \"plain_text\": \"] \",\n" +
                "                \"href\": null\n" +
                "            },\n" +
                "            {\n" +
                "                \"type\": \"text\",\n" +
                "                \"text\": {\n" +
                "                    \"content\": \" " +  this.user + " \",\n" +
                "                    \"link\": null\n" +
                "                },\n" +
                "                \"annotations\": {\n" +
                "                    \"bold\": true,\n" +
                "                    \"italic\": false,\n" +
                "                    \"strikethrough\": false,\n" +
                "                    \"underline\": false,\n" +
                "                    \"code\": false,\n" +
                "                    \"color\": \"default\"\n" +
                "                },\n" +
                "                \"plain_text\": \" "+ this.user + " \",\n" +
                "                \"href\": null\n" +
                "            },\n" +
                "            {\n" +
                "                \"type\": \"text\",\n" +
                "                \"text\": {\n" +
                "                    \"content\": \" : "+ this.contents + " \",\n" +
                "                    \"link\": null\n" +
                "                },\n" +
                "                \"annotations\": {\n" +
                "                    \"bold\": false,\n" +
                "                    \"italic\": false,\n" +
                "                    \"strikethrough\": false,\n" +
                "                    \"underline\": false,\n" +
                "                    \"code\": false,\n" +
                "                    \"color\": \"default\"\n" +
                "                },\n" +
                "                \"plain_text\": \" :" + this.contents +" \",\n" +
                "                \"href\": null\n" +
                "            }\n" +
                "        ],\n" +
                "        \"icon\": {\n" +
                "            \"type\": \"emoji\",\n" +
                "            \"emoji\": \"💬\"\n" +
                "        },\n" +
                "        \"color\": \"gray_background\"\n" +
                "    }\n" +
                "}";





        RequestBody requestBody = RequestBody.create(JSON, json);

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
                System.out.println("PATCH 요청이 실패하였습니다. 응답 코드: " + response.toString());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    public String retrieveNotionBlock() {

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

                JSONObject data = new JSONObject(response.toString());
                String formattedJsonString = data.toString(4);
                JSONObject data1 = new JSONObject(formattedJsonString);

                JSONArray results = data1.getJSONArray("results");

                for (int i = 0; i < results.length(); i++) {
                    JSONObject block = results.getJSONObject(i);
                    String blockType = block.getString("type");

                    if (blockType.equals("callout")) {
                        JSONArray richText = block.getJSONObject("callout").getJSONArray("text");

                        for (int j = 0; j < richText.length(); j++) {
                            JSONObject text = richText.getJSONObject(j);
                            String content = text.getJSONObject("text").getString("content");

                            if (content.contains(this.time)) {  //해당 시간값으로 찾는 부분
                                String blockId = block.getString("id");
                                System.out.println("Block ID: " + blockId);
                                return blockId;
                            }
                        }
                    }
                }

            } else {
//                System.out.println("Error - Response Code: " + responseCode);


            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }


    public void setDocumentId(String documentId, String requestBody) throws Exception {
        System.out.println("documentId = " + documentId);
        ClerkInfo clerkInfo = firebaseMeetingsServiceImpl.getClerkInfo(documentId);

        DecordJsonService decodeJsonService = new DecordJsonService(requestBody);

        String contents = decodeJsonService.getContents();
        String time = decodeJsonService.getTime();
        String user = decodeJsonService.getUser();

        System.out.println("contents = " + contents);
        System.out.println("time = " + time);
        
        this.contents = contents;
        this.user = user ;
        this.accessToken = clerkInfo.getAccessToken();
        this.pageId = clerkInfo.getPageId();
        this.time = time;

        System.out.println("accessToken = " + accessToken);
        System.out.println("pageId = " + pageId);
    }

    public void editNotion() {
        updateNotionBlock(retrieveNotionBlock());
    }

    public void deleteNotion() {
        deleteNotionBlock(retrieveNotionBlock());
    }
}
