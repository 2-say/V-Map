package ParkLab.VMap.model.Service.zoom;

import ParkLab.VMap.model.Service.firebase.FirebaseMeetingsServiceImpl;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.http.HttpHeaders;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

public class ZoomMeetingServiceImpl {
    private final String apiKey = "OQASXCsHTM-8G9IUVfdNCw";
    private final String apiSecret = "ni28glTXtwdRBz3Kcoeqw2KAgrWMcPJuBXGB";
    private String startUrl;
    private String joinUrl;
    private String meetingId;
    private String documentId;
    FirebaseMeetingsServiceImpl firebaseMeetingsService = new FirebaseMeetingsServiceImpl();

    public void createZoomMeeting(String documentId) throws NoSuchAlgorithmException, InvalidKeyException, UnsupportedEncodingException {
        this.documentId = documentId;

        // JWT 토큰 생성
        long exp = LocalDateTime.now().plus(Duration.ofHours(2)).atZone(ZoneId.systemDefault()).toEpochSecond();
        Map<String, Object> payload = new HashMap<>();
        payload.put("iss", apiKey);
        payload.put("exp", exp);

        String base64UrlHeader = base64UrlEncode("{\"alg\": \"HS256\", \"typ\": \"JWT\"}");
        String base64UrlPayload = base64UrlEncode(new Gson().toJson(payload));
        String signingInput = base64UrlHeader + "." + base64UrlPayload;
        Mac hmacSha256 = Mac.getInstance("HmacSHA256");
        hmacSha256.init(new SecretKeySpec(apiSecret.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        byte[] signatureBytes = hmacSha256.doFinal(signingInput.getBytes(StandardCharsets.UTF_8));
        String base64UrlSignature = base64UrlEncode(signatureBytes);
        String token = signingInput + "." + base64UrlSignature;

        // Zoom API를 이용한 회의 생성
        String url = "https://api.zoom.us/v2/users/me/meetings";

        HttpPost request = new HttpPost(url);
        request.addHeader(HttpHeaders.AUTHORIZATION, "Bearer " + token);
        request.addHeader(HttpHeaders.CONTENT_TYPE, "application/json");

        JsonObject data = new JsonObject();
        data.addProperty("topic", "Zoom Meeting");
        data.addProperty("type", 2);
        data.addProperty("start_time", "2023-05-03T13:00:00Z");
        data.addProperty("duration", 60);
        data.addProperty("timezone", "Asia/Seoul");
        data.addProperty("agenda", "This is a test meeting");

        request.setEntity(new StringEntity(data.toString(), "UTF-8"));

        try (CloseableHttpClient client = HttpClientBuilder.create().build();
             CloseableHttpResponse response = client.execute(request)) {
            int statusCode = response.getStatusLine().getStatusCode();
            if (statusCode == 201) {
                String responseBody = EntityUtils.toString(response.getEntity());
                JsonObject responseData = new Gson().fromJson(responseBody, JsonObject.class);
                startUrl = responseData.get("start_url").getAsString();
                joinUrl = responseData.get("join_url").getAsString();
                meetingId = responseData.get("id").getAsString();

                String startTimeString = responseData.get("start_time").getAsString();
                LocalDateTime startTime = LocalDateTime.parse(startTimeString, DateTimeFormatter.ISO_DATE_TIME);
                int duration = data.get("duration").getAsInt();

                System.out.println("Start URL: " + startUrl);
                System.out.println("Join URL: " + joinUrl);
                System.out.println("Start Time: " + startTime);
                System.out.println("meetingId = " + meetingId);

                updateMeetingUrl();
            } else {
                System.out.println("Failed to create Zoom meeting. Status code: " + statusCode);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void endZoomMeeting(String documentId) throws Exception {
        this.documentId = documentId;
        String endMeetingId = getMeetingId();

        String url = "https://api.zoom.us/v2/meetings/" + endMeetingId + "/status";

        HttpPut request = new HttpPut(url);
        request.addHeader(HttpHeaders.AUTHORIZATION, "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6Ik9RQVNYQ3NIVE0tOEc5SVVWZmROQ3ciLCJleHAiOjE2ODUyNjU3NTAsImlhdCI6MTY4NTI2MDM1MX0.BFPzCYKiDJSOvCZoXiQNsyZ2WXzChy0vlbJyxBFNyFA");
        request.addHeader(HttpHeaders.CONTENT_TYPE, "application/json");

        JsonObject body = new JsonObject();
        body.addProperty("action", "end");

        request.setEntity(new StringEntity(body.toString(), "UTF-8"));

        try (CloseableHttpClient client = HttpClientBuilder.create().build();
             CloseableHttpResponse response = client.execute(request)) {
            int statusCode = response.getStatusLine().getStatusCode();
            if (statusCode == 204) {
                System.out.println("Zoom meeting ended successfully.");
            } else {
                System.out.println("Failed to end Zoom meeting. Status code: " + statusCode);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String base64UrlEncode(String input) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(input.getBytes(StandardCharsets.UTF_8));
    }

    private String base64UrlEncode(byte[] input) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(input);
    }

    private void updateMeetingUrl() throws Exception {
        Map<String, Object> updates = new HashMap<>();
        updates.put("zoomUrlClerk", startUrl);
        updates.put("zoomUrlEtc", joinUrl);
        updates.put("zoomMeetingId", meetingId);
        firebaseMeetingsService.updateFirebaseMeetingUrl(documentId, updates);
    }

    private String getMeetingId() throws Exception {
        return firebaseMeetingsService.getFirebaseMeetingId(documentId);
    }
}
