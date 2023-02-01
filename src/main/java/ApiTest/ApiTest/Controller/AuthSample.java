package ApiTest.ApiTest.Controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;

public class AuthSample {

    public AuthSample() {
    }

    public String Auth() throws IOException {
        URL url = new URL("https://openapi.vito.ai/v1/authenticate");
        HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
        httpConn.setRequestMethod("POST");
        httpConn.setRequestProperty("accept", "application/json");
        httpConn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        httpConn.setDoOutput(true);

        String data = "client_id=xXfw1_ax0m0mbrlQUsYN&client_secret=VKGZCeuFBXLkYjifJzrN_Tv-qfie0ZjPMHYMPmQh";

        byte[] out = data.getBytes(StandardCharsets.UTF_8);

        OutputStream stream = httpConn.getOutputStream();
        stream.write(out);

        InputStream responseStream = httpConn.getResponseCode() / 100 == 2
                ? httpConn.getInputStream()
                : httpConn.getErrorStream();
        Scanner s = new Scanner(responseStream).useDelimiter("\\A");
        String response = s.hasNext() ? s.next() : "";
        s.close();
        System.out.println(response);

        return response;
    }

    public String getAuth() throws IOException {
        String s = Auth();

        String open = "token\":\"";
        String close = "\"";

        int start = s.indexOf(open);
        int end = s.indexOf(close, start+open.length());

        String auth = s.substring(start+open.length(), end);

        return auth;
    }
}
