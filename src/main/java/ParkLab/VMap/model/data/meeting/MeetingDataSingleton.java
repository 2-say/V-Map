package ParkLab.VMap.model.data.meeting;

import java.util.List;

public class MeetingDataSingleton {
    // Singleton 객체
    private static final MeetingDataSingleton INSTANCE = new MeetingDataSingleton();

    // 데이터 변수
    private String meetingName;
    private List<String> meetingParticipants;
    private String startTime;
    private String contents;
    private String time;
    private String user;


    // 생성자는 private으로 선언하여 외부에서 객체 생성 방지
    private MeetingDataSingleton() {
    }

    // Singleton 객체 반환
    public static MeetingDataSingleton getInstance() {
        return INSTANCE;
    }

    public String getMeetingName() {
        return meetingName;
    }

    public void setMeetingName(String meetingName) {
        this.meetingName = meetingName;
    }

    public List<String> getMeetingParticipants() {
        return meetingParticipants;
    }

    public void setMeetingParticipants(List<String> meetingParticipants) {
        this.meetingParticipants = meetingParticipants;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getContents() {
        return contents;
    }

    public void setContents(String contents) {
        this.contents = contents;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }
}
