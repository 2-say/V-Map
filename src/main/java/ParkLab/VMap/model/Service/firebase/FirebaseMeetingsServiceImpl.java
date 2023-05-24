package ParkLab.VMap.model.Service.firebase;

import ParkLab.VMap.model.data.ClerkInfo;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class FirebaseMeetingsServiceImpl {
    public static final String COLLECTION_NAME_MEETINGS = "meetings";

    // documentId contents 의 필드를 불러서 반환해주는 함수
    public List<Map<String, Object>> getContents(String documentId) throws Exception {
        Firestore db = FirestoreClient.getFirestore();

        DocumentSnapshot documentSnapshot = db
                .collection(COLLECTION_NAME_MEETINGS)
                .document(documentId)
                .get()
                .get();

        if (documentSnapshot.exists()) {
            List<Map<String, Object>> data = (List<Map<String, Object>>) documentSnapshot.get("contents");
            if (data != null) {
                return data;
            }
        }
        return null;
    }

    public ClerkInfo getClerkInfo(String documentId) throws Exception {
        Firestore db = FirestoreClient.getFirestore();

        DocumentSnapshot documentSnapshot = db.
                collection(COLLECTION_NAME_MEETINGS).
                document(documentId).
                get().
                get();

        ClerkInfo clerkInfo = new ClerkInfo();

        if (documentSnapshot.exists()) {
            Map<String, Object> data = (Map<String, Object>) documentSnapshot.get("clerk");
            if (data != null) {
                clerkInfo.setAccessToken((String) data.get("accessToken"));
                clerkInfo.setPageId((String) data.get("pageId"));
            }
        }

        return clerkInfo;
    }
}
