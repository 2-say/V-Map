package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.notion.NotionPatchServiceImpl;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@Scope("prototype")
public class NotionPatchController {
    private NotionPatchServiceImpl notionPatchServiceImp;

    public NotionPatchController() {
        this.notionPatchServiceImp = new NotionPatchServiceImpl();
    }

    @PostMapping("/patchNotion")
    @ResponseBody
    public void patchToNotion(@RequestParam("documentId") String documentId, @RequestBody String requestBody) throws Exception  {
        notionPatchServiceImp.patchToNotion(documentId, requestBody);
    }
}
