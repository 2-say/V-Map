package ParkLab.VMap.controller.notion;
import ParkLab.VMap.model.Service.notion.NotionApi;
import java.util.ArrayList;
import java.util.List;

public class NotionWriterController {
    NotionApi notionApi = new NotionApi();
    List<String> contents = new ArrayList<>();

    public void post(String content) throws Exception {

        System.out.println("결과");
        System.out.println(content);
        contents.add(content);  //0
//        contents.add("banana"); //1
//        contents.add("orange"); //깃 데스크톱 테스트
        notionApi.createBlock(contents);

    }

}
