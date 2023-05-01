package ParkLab.VMap.controller.textrank;

import ParkLab.VMap.model.Service.python.CallAgenda;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AgendaController {
    @GetMapping("/agenda")
    public static void agenda() {
        String[] command = new String[3];

        /*local test*/
//        command[0] = "C:/Users/xenon/AppData/Local/Programs/Python/Python310/python.exe";
//        command[1] = "D:/users/GitHub/V-Map/python/textrank.py";
//        command[2] = "D:/users/GitHub/V-Map/data/test.txt";

        /*server test*/
        command[0] = "/usr/bin/python3";
        command[1] = "/home/lab329/VMap/python/agenda.py";
        command[2] = "/home/lab329/VMap/data/data2.txt";

        CallAgenda callAgenda = new CallAgenda(command);
        try {
            callAgenda.execPython();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
