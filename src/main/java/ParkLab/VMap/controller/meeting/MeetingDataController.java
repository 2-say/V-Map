package ParkLab.VMap.controller.meeting;

import ParkLab.VMap.model.data.meeting.Meeting;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.util.List;

public class MeetingDataController {
    private Meeting meetingData;

    public Meeting getMeetingData() {
        return meetingData;
    }

    @PostMapping("/start")
    public void startMeeting(@RequestParam String title,
                             @RequestParam List<String> username,
                             @RequestParam String time) throws IOException {
        meetingData.setTitle(title);
        meetingData.setUserName(username);
        meetingData.setStartTime(time);
    }

    @PostMapping("/start")
    public void playMeeting(@RequestParam String contents,
                            @RequestParam String time) throws IOException {
        meetingData.addContents(contents);
        meetingData.addTime(time);
    }
}
