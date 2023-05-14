package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.firebase.FirebaseServiceImpl;
import ParkLab.VMap.model.Service.notion.NotionWriterServiceImpl;
import ParkLab.VMap.model.data.Users;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@Scope("prototype")
public class NotionWriteController {

    private NotionWriterServiceImpl notionWriterServiceImpl;
    private FirebaseServiceImpl firebaseServiceImpl = new FirebaseServiceImpl();
    Users users = new Users();

    public NotionWriteController() {
        this.notionWriterServiceImpl = new NotionWriterServiceImpl();
    }

    @PostMapping("/postNotion")
    public void postNotion(@RequestParam("documentId") String documentId, @RequestBody String requestBody) throws Exception {
        String pageId = notionWriterServiceImpl.postNotion(documentId, requestBody);
        users.setPageId(pageId);
        firebaseServiceImpl.savePageId(documentId, users);
    }
}
