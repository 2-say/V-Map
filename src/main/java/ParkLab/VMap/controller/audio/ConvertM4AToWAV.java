package ParkLab.VMap.controller.audio;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class ConvertM4AToWAV {
    public static void main(String[] args) {
        try {
            // m4a 파일 경로
            String sourceFilePath = "/Users/isehui/develop/V-map_backend_clone/sample1.m4a";

            // 변환될 wav 파일 경로
            String targetFilePath = "/Users/isehui/develop/V-map_backend_clone/test111.wav";
            Process process = Runtime.getRuntime().exec("/bin/bash -c 'eval $(/opt/homebrew/bin/brew shellenv)'");
            String line1;
            BufferedReader input1 = new BufferedReader(new InputStreamReader(process.getInputStream()));
            while ((line1 = input1.readLine()) != null) {
                System.out.println(line1);
            }
            input1.close();

            // FFmpeg 실행
            String[] cmd = {"/opt/homebrew/Cellar/ffmpeg/5.1.2_6/bin/ffmpeg", "-i", sourceFilePath, "-vn", "-acodec", "pcm_s16le", "-ar", "44100", "-ac", "2", targetFilePath};
            Process p = Runtime.getRuntime().exec(cmd);

            // 실행 결과 출력
            String line;
            BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));
            while ((line = input.readLine()) != null) {
                System.out.println(line);
            }
            input.close();

            System.out.println("M4A to WAV conversion succeeded!");
        } catch (IOException e) {
            System.err.println("M4A to WAV conversion failed: " + e.getMessage());
        }
    }
}
