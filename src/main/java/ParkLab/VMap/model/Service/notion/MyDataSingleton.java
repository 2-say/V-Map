package ParkLab.VMap.model.Service.notion;

public class MyDataSingleton {
    // Singleton 객체
    private static final MyDataSingleton INSTANCE = new MyDataSingleton();

    // 데이터 변수
    private String data;
    private String token;

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
        System.out.println("siNGLE TON token = " + token);
    }

    // 생성자는 private으로 선언하여 외부에서 객체 생성 방지
    private MyDataSingleton() {}

    // Singleton 객체 반환
    public static MyDataSingleton getInstance() {
        return INSTANCE;
    }

    // 데이터 설정 및 조회 메소드
    public void setData(String data) {
        this.data = data;
    }

    public String getData() {
        return data;
    }
}