package ParkLab.VMap.controller.front;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class frontMainController {

    @GetMapping("/")
    public String redirectToMainPage() {
        return "redirect:https://v-map-874e3.web.app/#/";
    }
}