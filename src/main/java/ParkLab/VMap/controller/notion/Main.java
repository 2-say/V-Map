package ParkLab.VMap.controller.notion;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;


@RestController
public class Main {

    @GetMapping("/notion")
    public static void main(String[] args) throws Exception {
        NotionApi notionApi = new NotionApi();
        List<String> contents = new ArrayList<>();

        contents.add("회의제목 : 졸업 작품 프로젝트 4차 회의");  //0
        contents.add("주요 안건: 서버를 위해서 어떤 소프트웨어를 사용할 것인가? "); //1
        contents.add("내용: 간단하고 편리한 Firebase를 사용하자는 결론으로 도출되었습니다."); //2

        notionApi.createBlock(contents);
    }
}
