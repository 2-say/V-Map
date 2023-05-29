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

    public List<String> convertToList(String agenda) {
        String[] agendaItems = agenda.split("\\n\\d+\\. ");

        List<String> agendaList = new ArrayList<>();
        for (String item : agendaItems) {
            if (!item.isEmpty()) {
                agendaList.add(item.trim());
            }
        }

        return agendaList;
    }
}
