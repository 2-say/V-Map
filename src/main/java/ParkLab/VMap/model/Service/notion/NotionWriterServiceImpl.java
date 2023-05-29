package ParkLab.VMap.model.Service.notion;

import ParkLab.VMap.model.Service.DecodeJson.DecordJsonService;
import ParkLab.VMap.model.Service.firebase.FirebaseServiceImpl;
import ParkLab.VMap.model.data.Users;
import org.json.JSONObject;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

import java.io.File;
import java.io.IOException;
import java.util.List;


//나중 요청을 위해서 만든 입구(컨트롤러)
//Test.class 처럼 데이터를 넘겨주면 post 작동 가능

public class NotionWriterServiceImpl {
    private BlockWrite blockWrite = new BlockWrite();
    private NotionApi notionApi = new NotionApi();
    private final RestTemplate restTemplate = new RestTemplate();
    FirebaseServiceImpl firebaseServiceImpl = new FirebaseServiceImpl();
    ResponseEntity<String> responseEntity;
    public String postNotion(String documentId, String requestBody) throws Exception {
        String url = "https://api.notion.com/v1/pages/";
        DecordJsonService decodeJsonService = new DecordJsonService(requestBody);
        Users users = firebaseServiceImpl.getData(documentId);
        String accessToken = users.getAccessToken();
        String databaseId = users.getDataBaseId();


        String meetingName = decodeJsonService.getMeetingName();   //화의 제목
        String startTime = decodeJsonService.getStartTime();       //회의 시작 시간
        List<String> meetingParticipants = decodeJsonService.getMeetingParticipants();
        String participantsString = String.join(" ", meetingParticipants);   //회의 참가자



        String jsonString = "{\n" +
                "  \"parent\": {\n" +
                "    \"database_id\": \"" + databaseId + "\"\n" +
                "  },\n" +
                "  \"properties\": {\n" +
                "    \"유형\": {\n" +
                "      \"select\": {\n" +
                "        \"name\": \"회의\"\n" +
                "      }\n" +
                "    },\n" +
                "    \"이름\": {\n" +
                "      \"title\": [\n" +
                "        {\n" +
                "          \"text\": {\n" +
                "            \"content\": \"" + meetingName + "\"\n" +
                "          }\n" +
                "        }\n" +
                "      ]\n" +
                "    },\n" +
                "    \"이벤트 시간\": {\n" +
                "      \"type\": \"date\",\n" +
                "      \"date\": {\n" +
                "        \"start\": \"" + startTime + "\"\n" +
                "      }\n" +
                "    }\n" +
                "  },\n" +
                "  \"children\": [\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"heading_2\",\n" +
                "      \"heading_2\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"회의 제목: " + meetingName + "\\n\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"callout\",\n" +
                "      \"callout\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"요약:\"\n" +
                "            }\n" +
                "          }\n" +
                "        ],\n" +
                "        \"icon\": {\n" +
                "          \"type\": \"emoji\",\n" +
                "          \"emoji\": \"💬\"\n" +
                "        },\n" +
                "        \"color\": \"yellow_background\"\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"paragraph\",\n" +
                "      \"paragraph\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"\\n\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"heading_3\",\n" +
                "      \"heading_3\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"👨🏻‍💻 회의 참석자\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"divider\",\n" +
                "      \"divider\": {}\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"paragraph\",\n" +
                "      \"paragraph\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"" + participantsString + "\\n\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"heading_3\",\n" +
                "      \"heading_3\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"\\n📚 회의 요약\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"divider\",\n" +
                "      \"divider\": {}\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"paragraph\",\n" +
                "      \"paragraph\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"\\n\\n\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"heading_3\",\n" +
                "      \"heading_3\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"\\n📣 회의 안건\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"divider\",\n" +
                "      \"divider\": {}\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"numbered_list_item\",\n" +
                "      \"numbered_list_item\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"numbered_list_item\",\n" +
                "      \"numbered_list_item\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"1\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"paragraph\",\n" +
                "      \"paragraph\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"\\n\\n\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"heading_3\",\n" +
                "      \"heading_3\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"✅ To Do List\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"to_do\",\n" +
                "      \"to_do\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"TO DO: 1\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"to_do\",\n" +
                "      \"to_do\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"TO DO: 2\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"to_do\",\n" +
                "      \"to_do\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"TO DO: 3\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"to_do\",\n" +
                "      \"to_do\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"TO DO: 4\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"paragraph\",\n" +
                "      \"paragraph\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"\\n\\n\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"heading_3\",\n" +
                "      \"heading_3\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"(추가):\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"quote\",\n" +
                "      \"quote\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"추가(?)\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"paragraph\",\n" +
                "      \"paragraph\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"\\n\\n\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"heading_2\",\n" +
                "      \"heading_2\": {\n" +
                "        \"rich_text\": [\n" +
                "          {\n" +
                "            \"type\": \"text\",\n" +
                "            \"text\": {\n" +
                "              \"content\": \"🧾 회의 대본:\"\n" +
                "            }\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    },\n" +
                "    {\n" +
                "      \"object\": \"block\",\n" +
                "      \"type\": \"divider\",\n" +
                "      \"divider\": {}\n" +
                "    }\n" +
                "  ]\n" +
                "}";




        // HTTP 요청 헤더를 설정합니다.
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Notion-Version", "2021-08-16");
        headers.set("Authorization", "Bearer " + accessToken);

        // HTTP 요청 데이터를 설정합니다.
        HttpEntity<String> requestEntity = new HttpEntity<>(jsonString, headers);

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
        createTxtFile(pageId);
        return pageId;
    }









//    public String postNotion(String documentId, String requestBody) throws Exception {
//        DecordJsonService decodeJsonService = new DecordJsonService(requestBody);
//
//        List<BlockData> contents = new ArrayList<>();
//        String meetingName = decodeJsonService.getMeetingName();
//        String startTime = decodeJsonService.getStartTime();
//
//        List<String> meetingParticipants = decodeJsonService.getMeetingParticipants();
//        String participantsString = String.join(" ", meetingParticipants);
//
//
//        contents.add(new BlockData(" :", BlockType.HEADING_2));
//        contents.add(new BlockData(meetingName, BlockType.CALLOUT));
//
//        contents.add(new BlockData("회의 참석자", BlockType.HEADING_1));
//        contents.add(new BlockData(participantsString, BlockType.PARAGRAPH));
//
//        contents.add(new BlockData("회의 시간", BlockType.HEADING_1));
//        contents.add(new BlockData(startTime, BlockType.PARAGRAPH));
//
//
//        String JsonContentBlock = blockWrite.BlockWrite(contents);
//
//        //notionApi -> pageId 값 받아오기 (txt파일을 만들 때 필요)
//        String responseString = notionApi.postToNotion(documentId, JsonContentBlock, requestBody);
//        ObjectMapper objectMapper = new ObjectMapper();
//        Map<String, String> responseMap = objectMapper.readValue(responseString, new TypeReference<Map<String,String>>(){});
//        String pageIdString = responseMap.get("pageId");
//
//        //txt파일 생성
//        createTxtFile(pageIdString);
//
//        return pageIdString;
//    }

    private void createTxtFile(String pageId) throws IOException {
        String directoryPath = "/home/VMap/data/";
        String fileName = pageId + ".txt";
        File directory = new File(directoryPath);
        File file = new File(directoryPath + fileName);

        if (!directory.exists()) {
            directory.mkdirs(); // create directory if it does not exist
        }

        if (!file.exists()) {
            file.createNewFile();
        }

        System.out.println("Txt file created successfully!");
    }










}



//        contents.add(new BlockData("회의는 회사의 지난 분기 실적과 다음 분기 계획에 대해 이야기되었으며, 새로운 제품 " +
//                "출시와 해외 시장 개척, 인력 확보와 업무 프로세스 개선이 핵심 안건으로 논의되었다.", BlockType.PARAGRAPH));
//        contents.add(new BlockData("회의 참석자", BlockType.HEADING_1));
//        contents.add(new BlockData("이세희,임재경,이상현,조원희", BlockType.PARAGRAPH));
//
//        contents.add(new BlockData("\\n  :", BlockType.HEADING_2));
//        contents.add(new BlockData("회사의 이번 분기 실적과 다음 분기 계획에 대한 논의", BlockType.CALLOUT));
//
//
//        contents.add(new BlockData("\\n 회의 요약 : ", BlockType.HEADING_3));
//        contents.add(new BlockData("회의는 회사의 지난 분기 실적과 다음 분기 계획에 대해 이야기되었으며, 새로운 제품 " +
//                "출시와 해외 시장 개척, 인력 확보와 업무 프로세스 개선이 핵심 안건으로 논의되었다.", BlockType.PARAGRAPH));
//
//        contents.add(new BlockData("\\n 회의 안건 :", BlockType.HEADING_3));
//        contents.add(new BlockData("이번 분기 실적과 다음 분기 계획", BlockType.NUMBERED_LIST_ITEM));
//        contents.add(new BlockData("새로운 제품 출시와 해외 시장 개척", BlockType.NUMBERED_LIST_ITEM));
//        contents.add(new BlockData("인력 확보와 업무 프로세스 개선", BlockType.NUMBERED_LIST_ITEM));
//        contents.add(new BlockData("인력 확보와 업무 프로세스 개선", BlockType.NUMBERED_LIST_ITEM));
//
//
//        contents.add(new BlockData(" \\n \\n ", BlockType.PARAGRAPH));
//        contents.add(new BlockData("해결해야할 문제1 :  문제가 무엇인가? ", BlockType.TO_DO));
//        contents.add(new BlockData("해결해야할 문제2 :  정신이 나갈것 같은가? ", BlockType.TO_DO));
//
//
//        contents.add(new BlockData(" \\n \\n ", BlockType.PARAGRAPH));
//        contents.add(new BlockData("회장님 지시사항 :", BlockType.HEADING_3));
//        contents.add(new BlockData("다들 모두 고생이 많으며 회사의 정신을 이끌어서 V-MAP 어플리케이션 " +
//                "완성을 위해서 야근은 기본이며, 월급은 생각하지도 말고 열심히 일해주길 바란다. 모두 " +
//                "MZ같은 생각은 버리고 끈기를 가지고 열심히 야근 진행하도록 . 이만. ", BlockType.QUOTE));
//
//
//
//
//        contents.add(new BlockData("\\n \\n \\n \\n ", BlockType.PARAGRAPH));
//
//
//
//        contents.add(new BlockData("-----------", BlockType.PARAGRAPH));
//        contents.add(new BlockData("회의 대본 :", BlockType.HEADING_2));