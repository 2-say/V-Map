package ParkLab.VMap.model.Service.notion;


/**
 * Notion 전송을 위해서 필요한 데이터 셋
 * 추가 가능 : 날짜
 */

public class BlockData {
    private String content;
    private BlockType type;

    public BlockData(String content, BlockType type) {
        this.content = content;
        this.type = type;
    }

    public String getContent() {
        return content;
    }

    public BlockType getType() {
        return type;
    }
}
