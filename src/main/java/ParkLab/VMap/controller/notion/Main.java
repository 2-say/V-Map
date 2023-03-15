package ParkLab.VMap.controller.notion;

import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) throws Exception {
        NotionApi notionApi = new NotionApi();
        List<String> contents = new ArrayList<>();
        contents.add("apple");  //0
        contents.add("banana"); //1
        contents.add("orange"); //깃 데스크톱 테스트
        notionApi.createBlock(contents);
    }
}
