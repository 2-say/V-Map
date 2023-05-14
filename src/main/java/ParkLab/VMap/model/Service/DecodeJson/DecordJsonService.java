package ParkLab.VMap.model.Service.DecodeJson;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.ArrayList;
import java.util.List;

public class DecordJsonService {
    private String meetingName;
    private List<String> meetingParticipants;
    private String startTime;
    private String time;
    private String accessToken;
    private String databaseId;
    private String pageId;
    private String contents;
    private String user;

    public DecordJsonService(String requestBody) throws Exception {
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(requestBody);

        this.meetingName = jsonNode.get("meetingName") != null ? jsonNode.get("meetingName").asText() : null;

        JsonNode participantsNode = jsonNode.get("meetingParticipants");
        if (participantsNode != null && participantsNode.isArray()) {
            this.meetingParticipants = new ArrayList<>();
            for (JsonNode participantNode : participantsNode) {
                this.meetingParticipants.add(participantNode.asText());
            }
        } else {
            this.meetingParticipants = null;
        }

        this.contents = jsonNode.get("contents") != null ? jsonNode.get("contents").asText() : null;
        this.startTime = jsonNode.get("startTime") != null ? jsonNode.get("startTime").asText() : null;
        this.accessToken = jsonNode.get("accessToken") != null ? jsonNode.get("accessToken").asText() : null;
        this.databaseId = jsonNode.get("databaseId") != null ? jsonNode.get("databaseId").asText() : null;
        this.time = jsonNode.get("time") != null ? jsonNode.get("time").asText() : null;
        this.user = jsonNode.get("user") != null ? jsonNode.get("user").asText() : null;
        this.pageId = jsonNode.get("pageId") != null ? jsonNode.get("pageId").asText() : null;
    }

    public String getPageId() {
        return pageId;
    }

    public void setPageId(String pageId) {
        this.pageId = pageId;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public void setMeetingName(String meetingName) {
        this.meetingName = meetingName;
    }

    public String getContents() {
        return contents;
    }

    public void setContents(String contents) {
        this.contents = contents;
    }

    public void setMeetingParticipants(List<String> meetingParticipants) {
        this.meetingParticipants = meetingParticipants;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public void setDatabaseId(String databaseId) {
        this.databaseId = databaseId;
    }

    public String getMeetingName() {
        return meetingName;
    }

    public List<String> getMeetingParticipants() {
        return meetingParticipants;
    }

    public String getStartTime() {
        return startTime;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public String getDatabaseId() {
        return databaseId;
    }

}