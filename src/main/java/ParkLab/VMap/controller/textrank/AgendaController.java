package ParkLab.VMap.controller.textrank;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@RestController
public class AgendaController {
    @GetMapping("/agenda")
    @ResponseBody
    public String agenda() {
        String apiUrl = "http://127.0.0.1:5000/agenda";

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(apiUrl))
                .GET()
                .build();
        try {
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            System.out.println("Status code: " + response.statusCode());
            System.out.println("Response body: " + response.body());

            return response.body();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "agenda get null exception";
    }
}
