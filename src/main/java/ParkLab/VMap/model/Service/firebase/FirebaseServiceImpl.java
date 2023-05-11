package ParkLab.VMap.model.Service.firebase;

import ParkLab.VMap.model.data.Users;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
public class FirebaseServiceImpl {
    public static final String COLLECTION_NAME = "users";

    // FireStore 필드 업데이트
    public void saveData(String documentId, Map<String, Object> updates) throws Exception {
        Firestore db = FirestoreClient.getFirestore();

        // 필드 업데이트
        ApiFuture<com.google.cloud.firestore.WriteResult> apiFuture
                = db.collection(COLLECTION_NAME)
                .document(documentId)
                .update(updates);

        log.info(apiFuture.get().getUpdateTime().toString());
    }

    // accessToken, databaseId 필드 저장
    public void saveAccessToken(String documentId, Users users) throws Exception {
        // 업데이트할 필드의 내용
        Map<String, Object> updates = new HashMap<>();
        updates.put("accessToken", users.getAccessToken());
        updates.put("dataBaseId", users.getDataBaseId());

        // saveData() 메서드를 사용하여 필드 업데이트
        saveData(documentId, updates);
    }

    // pageId 필드 저장
    public void savePageId(String documentId, Users users) throws Exception {
        // 업데이트할 필드의 내용
        Map<String, Object> updates = new HashMap<>();
        updates.put("pageId", users.getPageId());

        // saveData() 메서드를 사용하여 필드 업데이트
        saveData(documentId, updates);
    }

    // documentId user 의 필드를 불러서 반환해주는 함수
    public Users getData(String documentId) throws Exception {
        Firestore db = FirestoreClient.getFirestore();

        DocumentSnapshot documentSnapshot = db.collection(COLLECTION_NAME).document(documentId).get().get();

        Users users = new Users();

        if (documentSnapshot.exists()) {
            Map<String, Object> data = documentSnapshot.getData();
            if (data != null) {
                users.setUserName((String) data.get("userName"));
                users.setEmail((String) data.get("email"));
                users.setAccessToken((String) data.get("accessToken"));
                users.setDataBaseId((String) data.get("dataBaseId"));
                users.setPageId((String) data.get("pageId"));
            }
        }
        return users;
    }
}
