package ParkLab.VMap.model.Service.stt;

import org.springframework.stereotype.Service;

import java.io.File;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class TranscribeSample {
    public TranscribeSample() {
    }

    public String Transcribe() throws Exception {
        String transcription;
        do {
            transcription = "";

            AuthSample authSample = new AuthSample();
            String auth = authSample.getAuth();

            File file = new File("/home/audio/output.wav");

            PostTranscribeSample postTranscribeSample = new PostTranscribeSample(auth, file);
            String id = postTranscribeSample.getId();

            GetTranscribeSample getTranscribeSample = new GetTranscribeSample(auth, id);
            String result = getTranscribeSample.getResult();

            System.out.println(result);

            Pattern pattern = Pattern.compile("\"msg\":\"(.*?)\"}");
            Matcher matcher = pattern.matcher(result);

            while (matcher.find()) {
                System.out.println("Match: " + matcher.group(1));
                transcription += matcher.group(1);
            }
        } while(transcription.equalsIgnoreCase("not found"));
        return transcription;
    }
}
