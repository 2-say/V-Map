package ParkLab.VMap.controller.notion;

import ParkLab.VMap.model.Service.notion.NotionApi;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.ArrayList;
import java.util.List;



public class NotionWriterController {

    NotionApi notionApi = new NotionApi();
    List<String> contents = new ArrayList<>();



    @GetMapping()
    public void post(Model model)throws Exception {
        contents.add("apple");  //0
        contents.add("banana"); //1
        contents.add("orange"); //깃 데스크톱 테스트
        notionApi.createBlock(contents);

    }

}
