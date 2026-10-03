import 'package:flutter/foundation.dart';

/// Het kern-datamodel van de app, losgekoppeld van de database.
///
/// De Drift-tabel genereert zijn eigen rij-klasse (`ProductRow`); de repository
/// vertaalt die naar dit domeinmodel zodat de rest van de app niets van Drift
/// hoeft te weten.
@immutable
class Product {
  const Product({
    required this.id,
    required this.naam,
    required this.houdbaarTot,
    required this.toegevoegdOp,
    this.aantal = 1,
    this.notitie,
  });

  /// Databank-id. Uniek per product.
  final int id;

  /// Naam van het product (verplicht).
  final String naam;

  /// Houdbaarheidsdatum (verplicht).
  final DateTime houdbaarTot;

  /// Aantal stuks van hetzelfde product. Standaard 1.
  final int aantal;

  /// Vrije notitie (optioneel).
  final String? notitie;

  /// Wanneer het product is toegevoegd.
  final DateTime toegevoegdOp;

  Product copyWith({
    int? id,
    String? naam,
    DateTime? houdbaarTot,
    int? aantal,
    String? notitie,
    DateTime? toegevoegdOp,
  }) {
    return Product(
      id: id ?? this.id,
      naam: naam ?? this.naam,
      houdbaarTot: houdbaarTot ?? this.houdbaarTot,
      aantal: aantal ?? this.aantal,
      notitie: notitie ?? this.notitie,
      toegevoegdOp: toegevoegdOp ?? this.toegevoegdOp,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Product &&
        other.id == id &&
        other.naam == naam &&
        other.houdbaarTot == houdbaarTot &&
        other.aantal == aantal &&
        other.notitie == notitie &&
        other.toegevoegdOp == toegevoegdOp;
  }

  @override
  int get hashCode =>
      Object.hash(id, naam, houdbaarTot, aantal, notitie, toegevoegdOp);

  @override
  String toString() =>
      'Product(id: $id, naam: $naam, houdbaarTot: $houdbaarTot, '
      'aantal: $aantal, notitie: $notitie, toegevoegdOp: $toegevoegdOp)';
}
