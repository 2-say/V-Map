import 'dart:io';

class NoCheckCertificateHttpOverrides extends HttpOverrides {//안전하지 않은 페이지 무시 하기 위한 클래스
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}