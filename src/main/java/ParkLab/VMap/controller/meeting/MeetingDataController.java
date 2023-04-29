package ParkLab.VMap.controller.meeting;

import ParkLab.VMap.model.Service.meeting.MeetingDataSingleton;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.util.List;

public class MeetingDataController {
    @PostMapping("/start")
    public void startMeeting(@RequestParam String title,
                             @RequestParam List<String> username,
                             @RequestParam String time) throws IOException {
        MeetingDataSingleton.getInstance().setTitle(title);
        MeetingDataSingleton.getInstance().setUserName(username);
        MeetingDataSingleton.getInstance().setStartTime(time);
    }

    @PostMapping("/start")
    public void playMeeting(@RequestParam String contents,
                            @RequestParam String time) throws IOException {
        MeetingDataSingleton.getInstance().addContents(contents);
        MeetingDataSingleton.getInstance().addTime(time);
    }
}
