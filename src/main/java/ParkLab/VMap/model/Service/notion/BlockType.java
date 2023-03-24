package ParkLab.VMap.model.Service.notion;

// 노션에서 사용할 수 있는 타입 목록
public enum BlockType {
    PARAGRAPH("paragraph"),
    HEADING_1("heading_1"),
    HEADING_2("heading_2"),
    HEADING_3("heading_3"),
    BULLETED_LIST_ITEM("bulleted_list_item"),
    NUMBERED_LIST_ITEM("numbered_list_item"),
    TO_DO("to_do"),
    TOGGLE("toggle"),
    CALLOUT("callout"),
    QUOTE("quote");

    private final String value;

    BlockType(String value) {
        this.value = value;
    }
    public String getValue() {
        return value;
    }
}
