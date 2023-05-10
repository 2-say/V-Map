package ParkLab.VMap.model.data;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class users {
    private String userName;
    private String email;
    private String accessToken;
    private String dataBaseId;
    private String pageId;
}