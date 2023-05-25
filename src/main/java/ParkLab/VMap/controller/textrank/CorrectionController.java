package ParkLab.VMap.controller.textrank;

import org.json.JSONObject;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class CorrectionController {

    @GetMapping("/Correction")
    public static void correction(@RequestParam String word) {
        String apiUrl = "http://127.0.0.1:5000/correction?word=" + word;

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(apiUrl))
                .GET()
                .build();
        try {
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            System.out.println("Status code: " + response.statusCode());
            System.out.println("Response body: " + response.body());
            JSONObject json = new JSONObject(); //JSON 교정 return 필요

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
