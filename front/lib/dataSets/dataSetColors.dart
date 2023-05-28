import 'dart:ui';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
//배경 색상
Color ccKeyColorBackground = HexColor("FAFAFA");
//상단부 앱바 색상
Color ccKeyColorGrey = HexColor("E6E6E6");
Color ccKeyColorGreen = HexColor("55C56A");
Color ccKeyColorCyan = HexColor("8BC4DA");
Color crKeyColorB1 = HexColor("0D1117");
Color crKeyColorB1F = HexColor("C6D4E2");
Color crKeyColorB1L = HexColor("1b2533");
Color crKeyColorB1Menu = HexColor("191e26");
Color crKeyColorB1MenuL = HexColor("282f3b");
Color crKeyColorB1MenuBtn = HexColor("363e4d");
Color crKeyColorB1Talk = HexColor("272E38");
