package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.notion.NotionEditServiceImpl;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@Scope("prototype") // 이게 없으면 ? : 여기서 쓰는 객체들을 싱글톤으로 사용한다. 누가? controller 어노테이션이!
public class NotionDeleteController {
    private NotionEditServiceImpl notionEditServiceImpl;
    public NotionDeleteController() {
        this.notionEditServiceImpl = new NotionEditServiceImpl();
    }
    @ResponseBody
    @PostMapping("/deleteNotion")
    public void editNotion (@RequestParam("documentId") String documentId, @RequestBody String requestBody) throws Exception {
        notionEditServiceImpl.setDocumentId(documentId, requestBody);
        notionEditServiceImpl.deleteNotion();
    }
}
