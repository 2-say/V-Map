package ParkLab.VMap.controller.zoom;

import ParkLab.VMap.model.Service.zoom.ZoomMeetingServiceImpl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ZoomMeetingEndController {
    private ZoomMeetingServiceImpl zoomMeetingCreatorService;
    public ZoomMeetingEndController() {
        this.zoomMeetingCreatorService = new ZoomMeetingServiceImpl();
    }
    @ResponseBody
    @GetMapping("/endMeeting")
    public void zoomMeetingCreator(@RequestParam("documentId") String documentId) throws Exception {
        zoomMeetingCreatorService.endZoomMeeting(documentId);
    }
}
