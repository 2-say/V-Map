package ParkLab.VMap.model.Service.notion;
public class BlockWrite {
    private String content;

    String childBlock(String content) {
        String json = "{\n"
                + "    \"object\": \"block\",\n"
                + "    \"type\": \"heading_2\",\n"
                + "    \"heading_2\": {\n"
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
