package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.notion.NotionWriterServiceImp;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class NotionWriteController {

    private NotionWriterServiceImp notionWriterServiceImp;

    public NotionWriteController() {
        this.notionWriterServiceImp = new NotionWriterServiceImp();
    }

    @GetMapping("/postNotion")
    public void postNotion(@RequestBody String requestBody) throws Exception {
        notionWriterServiceImp.postNotion(requestBody);
    }
}
