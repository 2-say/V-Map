package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.notion.NotionWriterServiceImpl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class NotionWriteController {

    private NotionWriterServiceImpl notionWriterServiceImpl;

    public NotionWriteController() {
        this.notionWriterServiceImpl = new NotionWriterServiceImpl();
    }

    @GetMapping("/postNotion")
    public String postNotion(@RequestBody String requestBody) throws Exception {
        return notionWriterServiceImpl.postNotion(requestBody);
    }
}
