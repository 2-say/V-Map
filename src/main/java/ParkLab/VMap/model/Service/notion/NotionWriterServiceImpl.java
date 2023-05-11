package ParkLab.VMap.model.Service.notion;

import ParkLab.VMap.model.Service.DecodeJson.DecordJsonService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


//나중 요청을 위해서 만든 입구(컨트롤러)
//Test.class 처럼 데이터를 넘겨주면 post 작동 가능

public class NotionWriterServiceImpl {
    private BlockWrite blockWrite = new BlockWrite();
    private NotionApi notionApi = new NotionApi();

    public String postNotion(String requestBody) throws Exception {
        DecordJsonService decodeJsonService = new DecordJsonService(requestBody);

        List<BlockData> contents = new ArrayList<>();
        String meetingName = decodeJsonService.getMeetingName();
        List<String> meetingParticipants = decodeJsonService.getMeetingParticipants();
        String startTime = decodeJsonService.getStartTime();


        contents.add(new BlockData("\\n  :", BlockType.HEADING_2));
        contents.add(new BlockData(meetingName, BlockType.CALLOUT));

        contents.add(new BlockData("회의 참석자", BlockType.HEADING_1));
        contents.add(new BlockData(meetingParticipants.toString(), BlockType.PARAGRAPH));

        contents.add(new BlockData("회의 시간", BlockType.HEADING_1));
        contents.add(new BlockData(startTime, BlockType.PARAGRAPH));


        String JsonContentBlock = blockWrite.BlockWrite(contents);


        //notionApi -> pageId 값 받아오기 (txt파일을 만들 때 필요)
        String responseString = notionApi.postToNotion(JsonContentBlock, requestBody);
        ObjectMapper objectMapper = new ObjectMapper();
        Map<String, String> responseMap = objectMapper.readValue(responseString, new TypeReference<Map<String,String>>(){});
        String pageIdString = responseMap.get("pageId");

        //txt파일 생성
        createTxtFile(pageIdString);

        return pageIdString;
    }

    private void createTxtFile(String pageId) throws IOException {
        String directoryPath = "/HOME/V-map/data/";
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