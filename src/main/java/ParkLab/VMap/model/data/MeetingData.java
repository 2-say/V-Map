package ParkLab.VMap.model.data;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class MeetingData {
    private String user;
    private String text;
    private String startTime;
    private String endTime;
}
