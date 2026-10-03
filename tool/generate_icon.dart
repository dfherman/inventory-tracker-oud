// Genereert het app-icoon, de adaptieve voorgrond en de splash-logo als PNG.
//
// Draai eenmalig (of na een ontwerpwijziging) met:
//   dart run tool/generate_icon.dart
//
// De uitvoer komt in assets/icon/ en wordt daarna door flutter_launcher_icons
// en flutter_native_splash naar de platformmappen verwerkt.
import 'dart:io';

import 'package:image/image.dart';

const int _size = 1024;
final Color _groen = ColorRgb8(0x5B, 0x9A, 0x78);
final Color _wit = ColorRgb8(0xFF, 0xFF, 0xFF);

/// Tekent een gestileerde voorraaddoos: een gevulde witte doos met een groene
/// dekselnaad en handgreep-sleuf.
void _tekenDoos(Image img) {
  // Gevulde witte doos.
  fillRect(img,
      x1: 296, y1: 356, x2: 728, y2: 728, color: _wit, radius: 44);
  // Groene dekselnaad die het deksel van de body scheidt.
  drawLine(img,
      x1: 300, y1: 470, x2: 724, y2: 470,
      color: _groen, thickness: 26, antialias: true);
  // Groene handgreep-sleuf in het deksel.
  fillRect(img,
      x1: 452, y1: 398, x2: 572, y2: 432, color: _groen, radius: 17);
}

void _schrijf(String pad, Image img) {
  final bestand = File(pad)..parent.createSync(recursive: true);
  bestand.writeAsBytesSync(encodePng(img));
  stdout.writeln('geschreven: $pad');
}

void main() {
  // 1) Vol icoon: groene achtergrond + witte doos (legacy/iOS/web).
  final icon = Image(width: _size, height: _size, numChannels: 4);
  fill(icon, color: _groen);
  _tekenDoos(icon);
  _schrijf('assets/icon/icon.png', icon);

  // 2) Adaptieve voorgrond: transparant + witte doos in de veilige zone.
  final voorgrond = Image(width: _size, height: _size, numChannels: 4);
  fill(voorgrond, color: ColorRgba8(0, 0, 0, 0));
  _tekenDoos(voorgrond);
  _schrijf('assets/icon/icon_foreground.png', voorgrond);

  // 3) Splash-logo: groen afgerond vierkant met witte doos op transparant,
  //    zodat het op zowel een lichte als donkere achtergrond zichtbaar is.
  final splash = Image(width: _size, height: _size, numChannels: 4);
  fill(splash, color: ColorRgba8(0, 0, 0, 0));
  fillRect(splash,
      x1: 200, y1: 200, x2: 824, y2: 824, color: _groen, radius: 120);
  _tekenDoos(splash);
  _schrijf('assets/icon/splash.png', splash);
}
