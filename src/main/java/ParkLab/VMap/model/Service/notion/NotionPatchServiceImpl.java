package ParkLab.VMap.model.Service.notion;

import ParkLab.VMap.model.Service.DecodeJson.DecordJsonService;
import ParkLab.VMap.model.Service.firebase.FirebaseMeetingsServiceImpl;
import ParkLab.VMap.model.data.ClerkInfo;
import org.springframework.http.*;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@RestController
public class NotionPatchServiceImpl {
    private final RestTemplate restTemplate = new RestTemplate();
    FirebaseMeetingsServiceImpl firebaseMeetingsService = new FirebaseMeetingsServiceImpl();
    public void patchToNotion(String documentId, String requestBody) throws Exception {
        System.out.println("documentId = " + documentId);
        // firebase 로 부터 user 의 정보를 받아옴
        ClerkInfo clerkInfo = firebaseMeetingsService.getClerkInfo(documentId);
        System.out.println("clerkInfo = " + clerkInfo);
        String accessToken = clerkInfo.getAccessToken();
        String pageId = clerkInfo.getPageId();

        System.out.println("accessToken = " + accessToken);
        System.out.println("pageId = " + pageId);

        DecordJsonService decodeJsonService = new DecordJsonService(requestBody);
        String user = decodeJsonService.getUser();
        String contents = decodeJsonService.getContents();
        String time = decodeJsonService.getTime();

        System.out.println("time = " + time);
        System.out.println("user = " + user);
        System.out.println("contents = " + contents);

        String url = "https://api.notion.com/v1/blocks/"+pageId+"/children/";
        String json = "{\n" +
                "   \"children\": [\n" +
                "      {\n" +
                "         \"object\": \"block\",\n" +
                "         \"type\": \"callout\",\n" +
                "         \"callout\": {\n" +
                "                \"rich_text\": [\n" +
                "                    {\n" +
                "                        \"type\": \"text\",\n" +
                "                        \"text\": {\n" +
                "                            \"content\": \"[\",\n" +
                "                            \"link\": null\n" +
                "                        },\n" +
                "                        \"annotations\": {\n" +
                "                            \"bold\": false,\n" +
                "                            \"italic\": false,\n" +
                "                            \"strikethrough\": false,\n" +
                "                            \"underline\": false,\n" +
                "                            \"code\": false,\n" +
                "                            \"color\": \"default\"\n" +
                "                        },\n" +
                "                        \"plain_text\": \"[\",\n" +
                "                        \"href\": null\n" +
                "                    },\n" +
                "                    {\n" +
                "                        \"type\": \"text\",\n" +
                "                        \"text\": {\n" +
                "                            \"content\": \"   " + time + " \",\n" +
                "                            \"link\": null\n" +
                "                        },\n" +
                "                        \"annotations\": {\n" +
                "                            \"bold\": false,\n" +
                "                            \"italic\": false,\n" +
                "                            \"strikethrough\": false,\n" +
                "                            \"underline\": false,\n" +
                "                            \"code\": false,\n" +
                "                            \"color\": \"orange_background\"\n" +
                "                        },\n" +
                "                        \"plain_text\": \" " + time + " \",\n" +
                "                        \"href\": null\n" +
                "                    },\n" +
                "                    {\n" +
                "                        \"type\": \"text\",\n" +
                "                        \"text\": {\n" +
                "                            \"content\": \"] \",\n" +
                "                            \"link\": null\n" +
                "                        },\n" +
                "                        \"annotations\": {\n" +
                "                            \"bold\": false,\n" +
                "                            \"italic\": false,\n" +
                "                            \"strikethrough\": false,\n" +
                "                            \"underline\": false,\n" +
                "                            \"code\": false,\n" +
                "                            \"color\": \"default\"\n" +
                "                        },\n" +
                "                        \"plain_text\": \"] \",\n" +
                "                        \"href\": null\n" +
                "                    },\n" +
                "                    {\n" +
                "                        \"type\": \"text\",\n" +
                "                        \"text\": {\n" +
                "                            \"content\": \" " + user + " \",\n" +
                "                            \"link\": null\n" +
                "                        },\n" +
                "                        \"annotations\": {\n" +
                "                            \"bold\": true,\n" +
                "                            \"italic\": false,\n" +
                "                            \"strikethrough\": false,\n" +
                "                            \"underline\": false,\n" +
                "                            \"code\": false,\n" +
                "                            \"color\": \"default\"\n" +
                "                        },\n" +
                "                        \"plain_text\": \" " + user + " \",\n" +
                "                        \"href\": null\n" +
                "                    },\n" +
                "                    {\n" +
                "                        \"type\": \"text\",\n" +
                "                        \"text\": {\n" +
                "                            \"content\": \" : " + contents + " \",\n" +
                "                            \"link\": null\n" +
                "                        },\n" +
                "                        \"annotations\": {\n" +
                "                            \"bold\": false,\n" +
                "                            \"italic\": false,\n" +
                "                            \"strikethrough\": false,\n" +
                "                            \"underline\": false,\n" +
                "                            \"code\": false,\n" +
                "                            \"color\": \"default\"\n" +
                "                        },\n" +
                "                        \"plain_text\": \" : " + contents + " \",\n" +
                "                        \"href\": null\n" +
                "                    }\n" +
                "                ],\n" +
                "                \"icon\": {\n" +
                "                    \"type\": \"emoji\",\n" +
                "                    \"emoji\": \"💬\"\n" +
                "                },\n" +
                "                \"color\": \"gray_background\"\n" +
                "            }\n" +
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
//        System.out.println("responseEntity = " + responseEntity);

        // HTTP 응답 결과를 확인합니다.
        if (responseEntity.getStatusCode() == HttpStatus.OK) {
            System.out.println("블록 작성 성공!");
        } else {
            System.out.println("블록 작성 실패!");
        }
        appendToFile(time,user,contents,pageId);
    }

    public void appendToFile(String time, String user, String contents, String pageId) throws IOException {
        String filePath = "/home/VMap/data/"+ pageId + ".txt"; // 파일 경로, 사용자 ID를 파일명에 포함
        //        String line = "[" + time + "] " + user + " : " + contents; // 파일에 추가할 한 줄 생성
        String line = user + " : " + contents; // 파일에 추가할 한 줄 생성
        List<String> lines = Files.readAllLines(Paths.get(filePath)); // 파일의 모든 라인을 읽어옴
        lines.add(line); // 새로운 한 줄을 리스트에 추가
        List<String> sortedLines = new ArrayList<>(); // 정렬된 라인들을 저장할 리스트 생성
        for (String currentLine : lines) {
            if (currentLine.startsWith("[")) { // 현재 라인이 시간 정보를 가지고 있는 경우
                if (!sortedLines.isEmpty()) { // 정렬된 라인들이 존재하는 경우
                    sortedLines.sort(Comparator.comparing(s -> s.substring(1, 9))); // 1번째부터 9번째까지의 문자열(시간)로 정렬
                }
            }
            sortedLines.add(currentLine); // 현재 라인을 정렬된 라인들 리스트에 추가
        }
        Files.write(Paths.get(filePath), sortedLines); // 정렬된 리스트를 파일에 덮어쓰기
    }







}