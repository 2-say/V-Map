package ParkLab.VMap.controller.notion;
public class BlockWrite {
    private String content;
    private String type = "heading_2";

    String childBlock(String content) {

        String json = "{\n"
                + "    \"object\": \"block\",\n"
                + "    \"type\": \""+ type + "\",\n"
                + "    \""+type+"\": {\n"
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
        return json;
    }
}
