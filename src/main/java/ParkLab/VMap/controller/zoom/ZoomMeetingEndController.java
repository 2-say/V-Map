package ParkLab.VMap.controller.zoom;

import ParkLab.VMap.model.Service.zoom.ZoomMeetingCreatorServiceImpl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ZoomMeetingEndController {
    private ZoomMeetingCreatorServiceImpl zoomMeetingCreatorService;
    public ZoomMeetingEndController() {
        this.zoomMeetingCreatorService = new ZoomMeetingCreatorServiceImpl();
    }
    @ResponseBody
    @GetMapping("/endMeeting")
    public void zoomMeetingCreator() throws Exception {
        zoomMeetingCreatorService.endZoomMeeting();
    }
}
