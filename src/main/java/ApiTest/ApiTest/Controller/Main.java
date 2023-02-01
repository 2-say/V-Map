package ApiTest.ApiTest.Controller;

import java.io.File;
import java.io.IOException;

public class Main {

    public static void main(String[] args) throws Exception {
        AuthSample authSample = new AuthSample();
        String auth = authSample.getAuth();

        File file = new File("sample.wav");
        PostTranscribeSample postTranscribeSample = new PostTranscribeSample(auth, file);
        String id = postTranscribeSample.getId();

        GetTranscribeSample getTranscribeSample = new GetTranscribeSample(auth, id);
        String result = getTranscribeSample.getResult();

        System.out.println(result);
    }
}
