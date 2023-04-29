package ParkLab.VMap.model.Service.meeting;

import java.util.List;

public class MeetingDataSingleton {
    // Singleton 객체
    private static final MeetingDataSingleton INSTANCE = new MeetingDataSingleton();

    // 데이터 변수
    private String title;
    private List<String> userName;
    private String startTime;
    private List<String> contents;
    private List<String> time;

    // 생성자는 private으로 선언하여 외부에서 객체 생성 방지
    private MeetingDataSingleton() {
    }

    // Singleton 객체 반환
    public static MeetingDataSingleton getInstance() {
        return INSTANCE;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public List<String> getUserName() {
        return userName;
    }

    public void setUserName(List<String> userName) {
        this.userName = userName;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public List<String> getContents() {
        return contents;
    }

    public void setContents(List<String> contents) {
        this.contents = contents;
    }

    public List<String> getTime() {
        return time;
    }

    public void setTime(List<String> time) {
        this.time = time;
    }

    public void addContents(String contents) {
        this.contents.add(contents);
    }

    public void addTime(String time) {
        this.time.add(time);
    }
}
