package ParkLab.VMap.controller.notion;

public class Main {
    public static void main(String[] args) throws Exception {

        NotionApi notionApi = new NotionApi();
        notionApi.createBlock("제목1", "이번에는 이런 내용을 작성해볼게요" +
                "그런데 이렇게 작성하면 어떻게 들어갈까요? 내용이 띄어쓰기가 반영을 될까요? 텍스트가 어떻게 작동될지 미지수네?");
    }
}
