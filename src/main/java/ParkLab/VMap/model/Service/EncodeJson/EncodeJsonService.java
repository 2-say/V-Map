package ParkLab.VMap.model.Service.EncodeJson;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class EncodeJsonService {

    public JSONObject createJson(String name, String data) {
        JSONObject json = new JSONObject();
        json.put(name, data);
        return json;
    }

    public Map<String, Object> convertJsonToMap(String jsonString) {
        JSONObject jsonObject = new JSONObject(jsonString);
        Map<String, Object> resultMap = jsonObject.toMap();
        return resultMap;
    }

    public List<String> convertToList(String input) {

        // Extract the agenda string from the JSON
        String agenda = input.substring(input.indexOf(":") + 2, input.length() - 2);

        // Split the agenda string into separate items
        String[] agendaItems = agenda.split("\\\\n");

        // Remove the numbering from each agenda item
        List<String> agendaList = new ArrayList<>();
        for (String item : agendaItems) {
            String[] parts = item.split("\\. ");
            if (parts.length > 1) {
                agendaList.add(parts[1]);
            }
        }

        System.out.println(agendaList);
        return agendaList;
    }

    public String extractValueFromJsonString(String jsonString, String key) {
        int startIndex = jsonString.indexOf("\"" + key + "\":");
        if (startIndex != -1) {
            startIndex += key.length() + 3; // ": " 다음 위치
            int endIndex = jsonString.indexOf("\"", startIndex);
            if (endIndex != -1) {
                return jsonString.substring(startIndex, endIndex);
            }
        }
        return null; // key를 찾지 못한 경우
    }
}
