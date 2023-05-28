package ParkLab.VMap.controller.zoom;

import ParkLab.VMap.model.Service.zoom.ZoomMeetingServiceImpl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ZoomMeetingCreateController {
    private ZoomMeetingServiceImpl zoomMeetingCreatorService;
    public ZoomMeetingCreateController() {
        this.zoomMeetingCreatorService = new ZoomMeetingServiceImpl();
    }
    @ResponseBody
    @GetMapping("/createMeeting")
    public void zoomMeetingCreator(@RequestParam("documentId") String documentId) throws Exception {
        zoomMeetingCreatorService.createZoomMeeting(documentId);
    }
}
