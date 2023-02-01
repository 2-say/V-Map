package ApiTest.ApiTest.Controller;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

public class GetTranscribeSample {
    String id;
    String jwtKey;

    public GetTranscribeSample(String jwtKey, String id) {
        this.jwtKey = jwtKey;
        this.id = id;
    }

    public String getResult() throws Exception {
        String status;
        String response;
        do {
            URL url = new URL("https://openapi.vito.ai/v1/transcribe/" + id);
            HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
            httpConn.setRequestMethod("GET");
            httpConn.setRequestProperty("accept", "application/json");
            httpConn.setRequestProperty("Authorization", "Bearer " + jwtKey);

            InputStream responseStream = httpConn.getResponseCode() / 100 == 2
                    ? httpConn.getInputStream()
                    : httpConn.getErrorStream();
            Scanner s = new Scanner(responseStream).useDelimiter("\\A");
            response = s.hasNext() ? s.next() : "";
            s.close();
//            System.out.println(response);

            String rp = response;
            String open = "status\":\"";
            String close = "\"";

            int start = rp.indexOf(open);
            int end = rp.indexOf(close, start + open.length());

            status = rp.substring(start + open.length(), end);

//            System.out.println(status);
        } while (status.equals("transcribing"));
        return response;
    }
}