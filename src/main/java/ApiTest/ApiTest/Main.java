package ApiTest.ApiTest;

import java.io.File;

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
