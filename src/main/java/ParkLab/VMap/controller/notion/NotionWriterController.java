package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.notion.BlockData;
import ParkLab.VMap.model.Service.notion.BlockType;
import ParkLab.VMap.model.Service.notion.BlockWrite;
import ParkLab.VMap.model.Service.notion.NotionApi;
import ParkLab.VMap.model.Service.stt.TranscribeSample;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;


//나중 요청을 위해서 만든 입구(컨트롤러)
//Test.class 처럼 데이터를 넘겨주면 post 작동 가능


@RestController
public class NotionWriterController {
    BlockWrite blockWrite = new BlockWrite();
    NotionApi notionApi = new NotionApi();
    String id;
    //List<BlockData> contents = new ArrayList<>();           //위를 묶은 리스트

    public void post(List<BlockData> contents, String accessToken, String databaseId) throws Exception {
        String JsonContentBlock = blockWrite.BlockWrite(contents);
        notionApi.postToNotion(JsonContentBlock,accessToken,databaseId);
    }

    @GetMapping("/postNotion")
    public static void Test(@RequestParam("accessToken") String accessToken, @RequestParam("databaseId") String databaseId) throws Exception {
        NotionWriterController notionWriterController = new NotionWriterController();
        List<BlockData> contents = new ArrayList<>();
        TranscribeSample transcribeSample = new TranscribeSample();

        contents.add(new BlockData("회의 참석자", BlockType.HEADING_1));
        contents.add(new BlockData("이세희,임재경,이상현,조원희", BlockType.PARAGRAPH));

        contents.add(new BlockData("\\n 회의 제목 :", BlockType.HEADING_2));
        contents.add(new BlockData("회사의 이번 분기 실적과 다음 분기 계획에 대한 논의", BlockType.CALLOUT));


        contents.add(new BlockData("\\n 회의 요약 : ", BlockType.HEADING_3));
        contents.add(new BlockData("회의는 회사의 지난 분기 실적과 다음 분기 계획에 대해 이야기되었으며, 새로운 제품 " +
                "출시와 해외 시장 개척, 인력 확보와 업무 프로세스 개선이 핵심 안건으로 논의되었다.", BlockType.PARAGRAPH));

        contents.add(new BlockData("\\n 회의 안건 :", BlockType.HEADING_3));
        contents.add(new BlockData("이번 분기 실적과 다음 분기 계획", BlockType.NUMBERED_LIST_ITEM));
        contents.add(new BlockData("새로운 제품 출시와 해외 시장 개척", BlockType.NUMBERED_LIST_ITEM));
        contents.add(new BlockData("인력 확보와 업무 프로세스 개선", BlockType.NUMBERED_LIST_ITEM));
        contents.add(new BlockData("인력 확보와 업무 프로세스 개선", BlockType.NUMBERED_LIST_ITEM));


        contents.add(new BlockData(" \\n \\n ", BlockType.PARAGRAPH));
        contents.add(new BlockData("해결해야할 문제1 :  문제가 무엇인가? ", BlockType.TO_DO));
        contents.add(new BlockData("해결해야할 문제2 :  정신이 나갈것 같은가? ", BlockType.TO_DO));


        contents.add(new BlockData(" \\n \\n ", BlockType.PARAGRAPH));
        contents.add(new BlockData("회장님 지시사항 :", BlockType.HEADING_3));
        contents.add(new BlockData("다들 모두 고생이 많으며 회사의 정신을 이끌어서 V-MAP 어플리케이션 " +
                "완성을 위해서 야근은 기본이며, 월급은 생각하지도 말고 열심히 일해주길 바란다. 모두 " +
                "MZ같은 생각은 버리고 끈기를 가지고 열심히 야근 진행하도록 . 이만. ", BlockType.QUOTE));




        contents.add(new BlockData("\\n \\n \\n \\n ", BlockType.PARAGRAPH));



        contents.add(new BlockData("-----------", BlockType.PARAGRAPH));
        contents.add(new BlockData("회의 대본 :", BlockType.HEADING_2));
//        contents.add(new BlockData(transcribeSample.Transcribe(), BlockType.CALLOUT));

        notionWriterController.post(contents,accessToken,databaseId);
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {

        return notionApi.getId();
    }
}
