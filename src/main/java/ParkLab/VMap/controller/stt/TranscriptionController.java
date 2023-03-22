package ParkLab.VMap.controller.stt;

import ParkLab.VMap.model.stt.AuthSample;
import ParkLab.VMap.model.stt.GetTranscribeSample;
import ParkLab.VMap.model.stt.PostTranscribeSample;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.io.File;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Controller
@Configuration
public class TranscriptionController {

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @GetMapping("/transcribe")
    public String transcribe(Model model) throws Exception {
        AuthSample authSample = new AuthSample();
        String auth = authSample.getAuth();

        File file = new File("./audio/output.wav");

        PostTranscribeSample postTranscribeSample = new PostTranscribeSample(auth, file);
        String id = postTranscribeSample.getId();

        GetTranscribeSample getTranscribeSample = new GetTranscribeSample(auth, id);
        String result = getTranscribeSample.getResult();

        System.out.println(result);

        Pattern pattern = Pattern.compile("\"msg\":\"(.*?)\"}");
        Matcher matcher = pattern.matcher(result);
        String transcription = "";
        while (matcher.find()) {
            System.out.println("Match: " + matcher.group(1));
            transcription += matcher.group(1);
        }

        ObjectMapper objectMapper = new ObjectMapper();
        String transcriptionJson = objectMapper.writeValueAsString(transcription);

        model.addAttribute("transcribe", transcriptionJson);

        return "transcribe";
    }

}