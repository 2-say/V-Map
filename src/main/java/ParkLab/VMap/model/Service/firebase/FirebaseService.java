package ParkLab.VMap.model.Service.firebase;

import ParkLab.VMap.model.data.users;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class FirebaseService {
    public static final String COLLECTION_NAME = "users";
    private String documentId = "M95Ca2Bl8tVuWHd9IMDQ";

    public void saveData(users users) throws Exception {
        Firestore db = FirestoreClient.getFirestore();
        ApiFuture<com.google.cloud.firestore.WriteResult> apiFuture
                = db.collection(COLLECTION_NAME).document(documentId).set(users);

        log.info(apiFuture.get().getUpdateTime().toString());
    }

}
