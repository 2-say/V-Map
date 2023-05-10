/**
 * Backend - Version : 0.3.1
 * 최종 수정 날짜 : 2023-05-11 00:37
 * commit by 임재경
 * commit contents : notionAuth firebase 연동
 * issue
 * 1. time 변수가 어떻게 넘어오나 확인해서, 정렬이 어떻게 되는지 확인해봐야함
 * 2. patch 시 저장되는 텍스트가 개행이 되는지 여부 -> 이것도 값이 넘어온 다음에 확인해봐야함 ..
 * 3. txt 저장 경로 수정
 * 4. notionAuth request param -> documentId 로 바꾸기
 * 5. documentId 를 firebase 에서 찾아와서 해당하는 유저 정보 긁어오기
 * 6. 그 유저 정보에서 databaseid 랑 accesstoken 추가해서 다시 업데이트
 * 7. 나머지 patch랑 post 도 firebase 연동 필요
 */

package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.firebase.FirebaseService;
import ParkLab.VMap.model.Service.notion.NotionAuthServiceImpl;
import ParkLab.VMap.model.data.users;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class NotionAuthController {
    private NotionAuthServiceImpl notionAuthServiceImpl;
    private FirebaseService firebaseService = new FirebaseService();
    users users = new users();
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
    public String handleNotionAuthRequest(@RequestParam("userName") String userName,@RequestParam("email") String email) {
        String authUrl= notionAuthServiceImpl.Test(); //authurl = notionApiTest

        users.setUserName(userName);
        users.setEmail(email);

        return authUrl;
    }

    @GetMapping("/getData")
    @ResponseBody
    public void find_database(@RequestParam("accessToken") String accessToken) throws Exception {
        users.setAccessToken(accessToken);
//        String database = notionAuthServiceImpl.find_database(accessToken);
        users.setDataBaseId(notionAuthServiceImpl.find_database(accessToken));
        firebaseService.saveData(users);
    }
}
