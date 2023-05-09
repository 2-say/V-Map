/**
 * Backend - Version : 0.2.0
 * 최종 수정 날짜 : 2023-05-09
 * 커밋한 sweet guy : 이세희 야스 ~
 */

package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.notion.NotionAuthServiceImpl;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class NotionAuthController {
    private NotionAuthServiceImpl notionAuthServiceImpl;

    public NotionAuthController() {
        this.notionAuthServiceImpl = new NotionAuthServiceImpl();
    }
    //노션 인증 URL 생성
    @GetMapping("/notionAuth")
    public String handleNotionAuthRequest() {
        String authUrl= notionAuthServiceImpl.Test();
        return authUrl;
    }

    @GetMapping("/notionApiTest")
    public String handleNotionAuthRequest1(@RequestParam("code") String code) throws JsonProcessingException {
        String authUrl = notionAuthServiceImpl.handleCallback(code);
        return authUrl;
    }

    @GetMapping("/getData")
    @ResponseBody
    public String find_database(@RequestParam("accessToken") String accessToken) {
        String database = notionAuthServiceImpl.find_database(accessToken);
        return database;
    }



}
