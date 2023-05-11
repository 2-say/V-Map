package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.firebase.FirebaseService;
import ParkLab.VMap.model.Service.notion.NotionWriterServiceImpl;
import ParkLab.VMap.model.data.users;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class NotionWriteController {

    private NotionWriterServiceImpl notionWriterServiceImpl;
    private FirebaseService firebaseService = new FirebaseService();
    users users = new users();

    public NotionWriteController() {
        this.notionWriterServiceImpl = new NotionWriterServiceImpl();
    }

    @GetMapping("/postNotion")
    public void postNotion(@RequestBody String requestBody) throws Exception {
        users.setPageId(notionWriterServiceImpl.postNotion(requestBody));
        firebaseService.saveData(users);
    }
}
