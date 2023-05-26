package ParkLab.VMap.controller.stt;

import ParkLab.VMap.model.Service.stt.TranscribeSample;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@Controller
@CrossOrigin
public class TranscriptionController {

    @GetMapping("/index")
    public void index() {
    }

    @GetMapping("/transcribe.html")
    public String transcribe(Model model) throws Exception {
        TranscribeSample transcribeSample = new TranscribeSample();
        String transcription = transcribeSample.Transcribe();

        String userId = "Jay";
        saveText(userId, transcription);

        ObjectMapper objectMapper = new ObjectMapper();
        String transcriptionJson = objectMapper.writeValueAsString(transcription);

        model.addAttribute("transcription", transcriptionJson);

        return "transcribe";
    }
    
    @PostMapping("/saveText")
    public ResponseEntity<String> saveText(@RequestParam("userId") String userId,
                                           @RequestBody String text) throws IOException {

        // 회원 정보를 통해 파일 이름 생성
        String fileName = "transcription_" + userId + "_" + new SimpleDateFormat("yyyy-MM-dd-HH:mm:ss").format(new Date()) + ".txt";
        String filePath = "./transcriptions/" + fileName;

        try {
            // 생성된 파일에 텍스트 저장
            FileWriter fileWriter = new FileWriter(filePath);
            fileWriter.write(text);
            fileWriter.close();

            return new ResponseEntity<>("Text saved successfully for user " + userId, HttpStatus.OK);

        } catch (IOException e) {
            e.printStackTrace();
            return new ResponseEntity<>("Error saving text for user " + userId, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}