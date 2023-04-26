package ParkLab.VMap.model.data.meeting;

import java.util.List;

public class Meeting {
    private String title;
    private List<String> userName;
    private String startTime;
    private List<String> contents;
    private List<String> time;

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

    public void addContents(String contents) {
        this.contents.add(contents);
    }

    public void addTime(String time) {
        this.time.add(time);
    }
}
