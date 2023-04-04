package ParkLab.VMap.controller.notion;

import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.net.URL;

public class APi {

    String authorizationRedirect = getAuthGrantType(callBackUrl);


    public static void main(String[] args) {
        System.out.println(getAuthGrantType(callBackUrl));
        //useBearerToken("033c789b-7b58-45d2-8703-635d2f75ad95");




    }




    //Wait for user to logIn and then
    //getAccessToken(with the authorizationCode from header name 'authorization_code', callbackUrl);
    //Then call useBearerToken('access_token')
    private static void useBearerToken(String bearerToken) {
        BufferedReader reader = null;
        try {
            URL url = new URL("https://api.notion.com/v1/oauth/token");
            HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();
            connection.setRequestProperty("Authorization", "Bearer " + bearerToken);
            connection.setDoOutput(true);
            connection.setRequestMethod("POST");
            reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String line = null;
            StringWriter out = new StringWriter(connection.getContentLength() > 0 ? connection.getContentLength() : 2048);
            while ((line = reader.readLine()) != null) {
                out.append(line);
            }
            String response = out.toString();
            System.out.println(response);
        } catch (Exception e) {
            System.out.println("e = " + e);
        }
    }
}
