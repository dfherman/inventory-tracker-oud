import 'package:intl/intl.dart';

/// De houdbaarheidsstatus van een product, afgeleid van de datum.
///
/// De bijbehorende kleuren staan in `StatusColors` (thema); deze enum bevat
/// bewust geen kleur zodat de logica losstaat van de presentatie.
enum Houdbaarheid {
  /// De houdbaarheidsdatum is verstreken.
  verlopen,

  /// Verloopt vandaag of binnen enkele dagen (< 3 dagen).
  bijna,

  /// Ruim houdbaar.
  ok,
}

/// Hulpfuncties voor datumnotatie en houdbaarheid, op één plek zodat de lijst
/// en de kaart dezelfde logica en opmaak gebruiken.
class DateFormatter {
  const DateFormatter._();

  /// Grens (in dagen) waaronder een product als "bijna verlopen" telt.
  static const int _bijnaDrempelDagen = 3;

  /// Formatteert een datum als "12 jul 2026" (Nederlandse afkorting).
  static String datum(DateTime date) {
    // intl gebruikt in het Nederlands een punt bij afgekorte maanden
    // ("jul."); die halen we weg voor een rustiger beeld.
    final tekst = DateFormat('d MMM yyyy', 'nl_NL').format(date);
    return tekst.replaceAll('.', '');
  }

  /// Aantal hele kalenderdagen tot [houdbaarTot], geteld vanaf [vanaf]
  /// (standaard vandaag). Negatief betekent dat de datum al is verstreken.
  ///
  /// Alleen de datum telt mee, niet het tijdstip: een product dat vandaag
  /// verloopt geeft 0, ongeacht het uur.
  static int dagenTot(DateTime houdbaarTot, {DateTime? vanaf}) {
    final nu = vanaf ?? DateTime.now();
    final vandaag = DateTime(nu.year, nu.month, nu.day);
    final doel =
        DateTime(houdbaarTot.year, houdbaarTot.month, houdbaarTot.day);
    return doel.difference(vandaag).inDays;
  }

  /// Bepaalt de houdbaarheidsstatus van [houdbaarTot].
  static Houdbaarheid status(DateTime houdbaarTot, {DateTime? vanaf}) {
    final dagen = dagenTot(houdbaarTot, vanaf: vanaf);
    if (dagen < 0) return Houdbaarheid.verlopen;
    if (dagen < _bijnaDrempelDagen) return Houdbaarheid.bijna;
    return Houdbaarheid.ok;
  }

  /// Een korte, menselijke omschrijving van de houdbaarheid, bijv.
  /// "Verlopen", "Verloopt vandaag", "Nog 1 dag" of "Nog 5 dagen".
  static String houdbaarheidLabel(DateTime houdbaarTot, {DateTime? vanaf}) {
    final dagen = dagenTot(houdbaarTot, vanaf: vanaf);
    if (dagen < 0) {
      final verstreken = -dagen;
      return verstreken == 1
          ? 'Gisteren verlopen'
          : '$verstreken dagen verlopen';
    }
    if (dagen == 0) return 'Verloopt vandaag';
    if (dagen == 1) return 'Nog 1 dag';
    return 'Nog $dagen dagen';
  }
}
