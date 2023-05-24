package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.firebase.FirebaseMeetingsServiceImpl;
import ParkLab.VMap.model.Service.notion.NotionEditServiceImpl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class NotionEditController {

    private NotionEditServiceImpl notionEditServiceImpl;
    private FirebaseMeetingsServiceImpl firebaseMeetingsServiceImpl;
    public NotionEditController() {
        this.notionEditServiceImpl = new NotionEditServiceImpl();
    }
    @ResponseBody
    @PostMapping("/editNotion")
    public void editNotion (@RequestParam("documentId") String documentId, @RequestBody String requestBody) throws Exception {
        notionEditServiceImpl.setDocumentId(documentId, requestBody);
    }
}
