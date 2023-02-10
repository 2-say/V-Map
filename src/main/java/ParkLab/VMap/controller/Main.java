package ParkLab.VMap.controller;
import java.io.File;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Main {

    public static void main(String[] args) throws Exception {
        AuthSample authSample = new AuthSample();
        String auth = authSample.getAuth();

        File file = new File("sample.wav");
        PostTranscribeSample postTranscribeSample = new PostTranscribeSample(auth, file);
        String id = postTranscribeSample.getId();

        GetTranscribeSample getTranscribeSample = new GetTranscribeSample(auth, id);
        String result = getTranscribeSample.getResult();

        //System.out.println(result);
        

        Pattern pattern = Pattern.compile("\"msg\":\"(.*?)\"}");
        Matcher matcher = pattern.matcher(result);
        while (matcher.find()) {
            System.out.println("Match: " + matcher.group(1));
        }



    }
}