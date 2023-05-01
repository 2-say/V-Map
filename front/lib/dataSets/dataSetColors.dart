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