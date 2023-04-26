package ParkLab.VMap.model.Service.meeting;

import ParkLab.VMap.model.data.meeting.Meeting;
import com.fasterxml.jackson.databind.ObjectMapper;

public class MeetingDao {
    public String convertMeetingData(Meeting meeting) throws Exception {
        ObjectMapper objectMapper = new ObjectMapper();
        String json = objectMapper.writeValueAsString(meeting);
        return json;
    }
}
