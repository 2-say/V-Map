package ParkLab.VMap.model.Service.notion;
import java.util.ArrayList;
import java.util.List;

public class BlockWrite {
    String completedTasks = new String();
    List<String> unmarkedBlocks = new ArrayList<>();

    public String BlockWrite(List<BlockData> dataList) throws Exception {
        createBlock(dataList);
        addCommasToBlocks();
        return completedTasks;
    }


    //입력 받은 데이터를 하나씩 꺼내서
    //하나의 블록 형식으로 가공하는 메서드
    public void createBlock(List<BlockData> contents) throws Exception {
        for(var content : contents) {
                //여기서 블록 만듬
                System.out.printf("type : %s   content : %s",content.getType() ,content.getContent() );
                childBlockMake(content.getType(),content.getContent());
        }
    }


    public void childBlockMake(BlockType type,String content) {
        String childBlock = "{\n"
                + "    \"object\": \"block\",\n"
                + "    \"type\": \""+ type.getValue() + "\",\n"
                + "    \""+type.getValue()+"\": {\n"
                + "        \"rich_text\": [\n"
                + "            {\n"
                + "                \"type\": \"text\",\n"
                + "                \"text\": {\n"
                + "                    \"content\": \"" + content + "\"\n"
                + "                }\n"
                + "            }\n"
                + "        ]\n"
                + "    }\n"
                + "}";
        unmarkedBlocks.add(childBlock);  // 반점이 작업되지 않은 블록들 리스트들
    }


    //반점을 찍는 메서드
    private void addCommasToBlocks() {
        for(var content : unmarkedBlocks) {

            if(unmarkedBlocks.indexOf(content) != unmarkedBlocks.size() - 1) //마지막 아닌 조건
            {
                completedTasks += content + ",\n" ;
            }
            else
                completedTasks += content;
        }
    }
}
