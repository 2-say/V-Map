package ParkLab.VMap.controller.audio;

import javax.sound.sampled.AudioFileFormat;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

//채널 합치는 곳
public class MultiChannelAudioMerger {
    public static void main(String[] args) {
        try {
            //왜 안돼? 
            File inputFile1 = new File("./audio/sample1.wav");
            File inputFile2 = new File("./audio/sample2.wav");
            ArrayList<File> inputFiles = new ArrayList<>(Arrays.asList(inputFile1, inputFile2));

            // Output file
            File outputFile = new File("./audio/output.wav");


            // Audio format
            AudioFormat audioFormat = AudioSystem.getAudioInputStream(inputFile1).getFormat();

            // Create an audio input stream for each file
            ArrayList<AudioInputStream> audioInputStreams = new ArrayList<>();
            for (File inputFile : inputFiles) {
                AudioInputStream audioInputStream = AudioSystem.getAudioInputStream(inputFile);
                audioInputStreams.add(audioInputStream);
            }

            // Merge audio input streams
            AudioInputStream audioInputStream = new AudioInputStream(
                    new MultiAudioInputStream(audioInputStreams),
                    audioFormat,
                    AudioSystem.getAudioInputStream(inputFile1).getFrameLength() + AudioSystem.getAudioInputStream(inputFile2).getFrameLength()
            );

            // Write output file
            AudioSystem.write(audioInputStream, AudioFileFormat.Type.WAVE, outputFile);

            // Close audio input streams
            for (AudioInputStream audioInputStream2 : audioInputStreams) {
                audioInputStream2.close();
                System.out.println("채널파일 제작 완료");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static class MultiAudioInputStream extends AudioInputStream {
        private final ArrayList<AudioInputStream> audioInputStreams;
        private int currentIndex = 0;

        public MultiAudioInputStream(ArrayList<AudioInputStream> audioInputStreams) {
            super(audioInputStreams.get(0), audioInputStreams.get(0).getFormat(), Long.MAX_VALUE);
            this.audioInputStreams = audioInputStreams;
        }

        public int read(byte[] b, int off, int len) throws IOException {
            int bytesRead = audioInputStreams.get(currentIndex).read(b, off, len);
            if (bytesRead == -1 && currentIndex + 1 < audioInputStreams.size()) {
                currentIndex++;
                bytesRead = read(b, off, len);
            }
            return bytesRead;
        }

        public void close() throws IOException {
            for (AudioInputStream audioInputStream : audioInputStreams) {
                audioInputStream.close();
            }
        }
    }
}
