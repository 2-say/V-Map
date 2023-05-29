package ParkLab.VMap.controller.textrank;

import ParkLab.VMap.model.Service.EncodeJson.EncodeJsonService;
import ParkLab.VMap.model.Service.firebase.FirebaseMeetingsServiceImpl;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Map;

@RestController
@CrossOrigin(origins = "*")
public class SummarizeController {

    FirebaseMeetingsServiceImpl firebaseMeetingsService = new FirebaseMeetingsServiceImpl();
    @GetMapping("/summarize")
    @ResponseBody
    public void summarize(@RequestParam("documentId") String documentId, @RequestParam("pageId") String pageId) {
        String apiUrl = "http://127.0.0.1:5000/summarize?pageId=" + pageId;

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(apiUrl))
                .GET()
                .build();
        try {
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            System.out.println("Status code: " + response.statusCode());
            System.out.println("Response body: " + response.body());

            EncodeJsonService encodeJsonService = new EncodeJsonService();
            Map<String, Object> resultMap = encodeJsonService.convertJsonToMap(response.body());




            firebaseMeetingsService.updateFirebaseMeetingSummarize(documentId, resultMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
