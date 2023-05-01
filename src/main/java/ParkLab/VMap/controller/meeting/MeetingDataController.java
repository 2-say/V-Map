package ParkLab.VMap.controller.meeting;

import ParkLab.VMap.model.data.meeting.MeetingDataSingleton;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class MeetingDataController {
    @PostMapping("/start")
    public ResponseEntity<String> startMeeting(@RequestBody String jsonData) throws IOException {

        JSONObject jsonObj = new JSONObject(jsonData);

        String meetingName = jsonObj.getString("meetingName");
        MeetingDataSingleton.getInstance().setMeetingName(meetingName);

        String time = jsonObj.getString("time");
        MeetingDataSingleton.getInstance().setStartTime(time);

        JSONArray participantsArray = jsonObj.getJSONArray("meetingParticipants");
        List<String> meetingParticipants = new ArrayList<>();
        for (int i = 0; i < participantsArray.length(); i++) {
            meetingParticipants.add(participantsArray.getString(i));
        }
        MeetingDataSingleton.getInstance().setMeetingParticipants(meetingParticipants);

        return ResponseEntity.ok("Meeting started successfully");
    }

    @PostMapping("/patch")
    public ResponseEntity<String> playMeeting(@RequestBody String jsonData) throws IOException {
        JSONObject jsonObj = new JSONObject(jsonData);

        String contents = jsonObj.getString("contents");
        MeetingDataSingleton.getInstance().setContents(contents);

        String time = jsonObj.getString("time");
        MeetingDataSingleton.getInstance().setTime(time);

        String user = jsonObj.getString("user");
        MeetingDataSingleton.getInstance().setUser(user);

        return ResponseEntity.ok("Meeting transmitted successfully");
    }
}
