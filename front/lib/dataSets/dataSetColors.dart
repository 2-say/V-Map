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

Color ccKeyColorBackground = HexColor("FAFAFA");
Color ccKeyColorGrey = HexColor("C8C8C8");
Color ccKeyColorGreen = HexColor("55C56A");
Color ccKeyColorCyan = HexColor("8BC4DA");