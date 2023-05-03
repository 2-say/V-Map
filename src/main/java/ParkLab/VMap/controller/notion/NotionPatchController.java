package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.notion.NotionPatchServiceImp;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class NotionPatchController {
    private NotionPatchServiceImp notionPatchServiceImp;

    public NotionPatchController() {
        this.notionPatchServiceImp = new NotionPatchServiceImp();
    }

    @GetMapping("/patchNotion")
    public void patchToNotion(@RequestBody String requestBody) throws Exception  {
        notionPatchServiceImp.patchToNotion(requestBody);
    }
}
