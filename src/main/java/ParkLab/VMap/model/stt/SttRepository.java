package ParkLab.VMap.model.stt;

import org.springframework.stereotype.Component;

@Component
public class SttRepository {
    private String text;

    public SttRepository(String text) {
        this.text = text;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
}