package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.notion.BlockData;
import ParkLab.VMap.model.Service.notion.BlockWrite;
import ParkLab.VMap.model.Service.notion.NotionApi;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


//나중 요청을 위해서 만든 입구(컨트롤러)
//Test.class 처럼 데이터를 넘겨주면 post 작동 가능


@RestController
public class NotionWriterController {
    BlockWrite blockWrite = new BlockWrite();
    NotionApi notionApi = new NotionApi();
    //List<BlockData> contents = new ArrayList<>();           //위를 묶은 리스트

    @GetMapping("/postNotion")
    public void post(List<BlockData> contents) throws Exception {
        String JsonContentBlock = blockWrite.BlockWrite(contents);
        notionApi.postToNotion(JsonContentBlock);
    }

}
