package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.firebase.FirebaseServiceImpl;
import ParkLab.VMap.model.Service.notion.NotionPatchServiceImpl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class NotionPatchController {
    private NotionPatchServiceImpl notionPatchServiceImp;
    private FirebaseServiceImpl firebaseServiceImpl = new FirebaseServiceImpl();

    public NotionPatchController() {
        this.notionPatchServiceImp = new NotionPatchServiceImpl();
    }

    @GetMapping("/patchNotion")
    public void patchToNotion(@RequestParam String documentId, @RequestBody String requestBody) throws Exception  {
        notionPatchServiceImp.patchToNotion(documentId, requestBody);
    }
}
