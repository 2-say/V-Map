package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.notion.NotionPatchServiceImpl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class NotionPatchController {
    private NotionPatchServiceImpl notionPatchServiceImp;

    public NotionPatchController() {
        this.notionPatchServiceImp = new NotionPatchServiceImpl();
    }

    @GetMapping("/patchNotion")
    public void patchToNotion(@RequestParam("documentId") String documentId, @RequestBody String requestBody) throws Exception  {
        notionPatchServiceImp.patchToNotion(documentId, requestBody);
    }
}
