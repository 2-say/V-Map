/**
 * Backend - Version : 1.2.2
 * 최종 수정 날짜 : 2023-05-25 18:50
 * commit by 이세희
 * commit contents
 *
 *
 * issue
 * 1. time 변수가 어떻게 넘어오나 확인해서, 정렬이 어떻게 되는지 확인해봐야함
 * 2. patch 시 저장되는 텍스트가 개행이 되는지 여부 -> 이것도 값이 넘어온 다음에 확인해봐야함 ..
 * 3. txt 저장 경로 수정
 * 4. firebase 에서 아직 meeting data가 추가가 안돼서, meeting data 부분은 구현을 안했음
 * 4-1. meeting data도 update 와 read 메소드가 필요하며 해당 메소드에 맞도록 notion 리팩토링 필요함
 * 4-2. 또한 기존에 회의 개설 시 나머지 사용자들의 patch 방식에 대해 회의가 필요함
 * 4-3. 안건 1. 기존대로 회의 참석자들의 accessToken과 pageId 를 덮어씌운다
 * 4-4. 안건 2. pageId 를 파라미터로 받아오고, documentId 를 받아와서
 * 4-5. patch user 정보를 활용하고 회의록을 기록하는 페이지는 pageId 로 인식하도록 한다.
 */

package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.firebase.FirebaseServiceImpl;
import ParkLab.VMap.model.Service.notion.NotionAuthServiceImpl;
import ParkLab.VMap.model.data.Users;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@CrossOrigin(origins = "*")
public class NotionAuthController {
    private NotionAuthServiceImpl notionAuthServiceImpl;
    private FirebaseServiceImpl firebaseServiceImpl = new FirebaseServiceImpl();
    Users users = new Users();
    String documentId;
    public NotionAuthController() {
        this.notionAuthServiceImpl = new NotionAuthServiceImpl();
    }
    //노션 인증 URL 생성
    @GetMapping("/notionApiTest")
    public String handleNotionAuthRequest1(@RequestParam("code") String code) throws JsonProcessingException {
        String authUrl = notionAuthServiceImpl.handleCallback(code);
        return authUrl;
    }

    @GetMapping("/notionAuth")
    public String handleNotionAuthRequest(@RequestParam("documentId") String documentId) {
        String authUrl= notionAuthServiceImpl.Test(); //authurl = notionApiTest
        this.documentId = documentId;
        return authUrl;
    }

    @GetMapping("/getData")
    @ResponseBody
    public void find_database(@RequestParam("accessToken") String accessToken) throws Exception {
        String databaseId = notionAuthServiceImpl.find_database(accessToken);

        users.setAccessToken(accessToken);
        users.setDataBaseId(databaseId);

        firebaseServiceImpl.saveAccessToken(documentId, users);
    }
}
