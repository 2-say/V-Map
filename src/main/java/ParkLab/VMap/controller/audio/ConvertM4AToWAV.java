package ParkLab.VMap.controller.audio;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class ConvertM4AToWAV {
    public static void main(String[] args) {
        try {
            // m4a 파일 경로
            String sourceFilePath = "/Users/isehui/Documents/Zoom/2023-03-19 13.58.23 세희 이님의 Zoom 회의/Audio Record/sample1.m4a";

            // 변환될 wav 파일 경로
            String targetFilePath = "/Users/isehui/Documents/Zoom/2023-03-19 13.58.23 세희 이님의 Zoom 회의/Audio Record/sample2.m4a";

            // FFmpeg 실행
            String[] cmd = {"ffmpeg", "-i", sourceFilePath, "-vn", "-acodec", "pcm_s16le", "-ar", "44100", "-ac", "2", targetFilePath};
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
