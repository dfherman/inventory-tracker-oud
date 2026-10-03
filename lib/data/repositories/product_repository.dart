import 'package:drift/drift.dart';

import '../../domain/models/product.dart';
import '../database/app_database.dart';

/// De sorteervolgorde van de voorraadlijst.
enum SortOrder {
  /// Alfabetisch op naam (A–Z).
  alfabetisch,

  /// Oplopend op houdbaarheidsdatum (verloopt eerst bovenaan).
  houdbaarheid,
}

/// De enige toegangspoort tot de productdata.
///
/// De UI praat nooit rechtstreeks met de database, maar altijd via deze
/// repository. Sorteren gebeurt hier, in de query.
class ProductRepository {
  ProductRepository(this._db);

  final AppDatabase _db;

  /// Reactieve stream van alle producten, gesorteerd volgens [order].
  ///
  /// De stream zendt automatisch een nieuwe lijst uit bij elke wijziging
  /// in de tabel, zodat de UI live meebeweegt.
  Stream<List<Product>> watchProducts(SortOrder order) {
    final query = _db.select(_db.products);

    switch (order) {
      case SortOrder.alfabetisch:
        // Hoofdletterongevoelig sorteren op naam.
        query.orderBy([
          (t) => OrderingTerm(expression: t.naam.lower()),
        ]);
      case SortOrder.houdbaarheid:
        query.orderBy([
          (t) => OrderingTerm(expression: t.houdbaarTot),
        ]);
    }

    return query.watch().map(
          (rows) => rows.map(_toDomain).toList(),
        );
  }

  /// Voegt een nieuw product toe en geeft het gegenereerde id terug.
  Future<int> addProduct({
    required String naam,
    required DateTime houdbaarTot,
    int aantal = 1,
    String? notitie,
  }) {
    return _db.into(_db.products).insert(
          ProductsCompanion.insert(
            naam: naam,
            houdbaarTot: houdbaarTot,
            aantal: Value(aantal),
            notitie: Value(notitie),
          ),
        );
  }

  /// Zet het aantal van een product op [aantal].
  ///
  /// Bij een aantal van 0 of lager wordt het product verwijderd.
  Future<void> updateAantal(int id, int aantal) async {
    if (aantal <= 0) {
      await deleteProduct(id);
      return;
    }
    await (_db.update(_db.products)..where((t) => t.id.equals(id))).write(
      ProductsCompanion(aantal: Value(aantal)),
    );
  }

  /// Verlaagt het aantal met één; bij aantal 1 wordt het product verwijderd.
  Future<void> verlaagAantal(Product product) {
    return updateAantal(product.id, product.aantal - 1);
  }

  /// Verhoogt het aantal met één.
  Future<void> verhoogAantal(Product product) {
    return updateAantal(product.id, product.aantal + 1);
  }

  /// Verwijdert een product definitief.
  Future<void> deleteProduct(int id) async {
    await (_db.delete(_db.products)..where((t) => t.id.equals(id))).go();
  }

  /// Vertaalt een Drift-rij naar het domeinmodel.
  Product _toDomain(ProductRow row) {
    return Product(
      id: row.id,
      naam: row.naam,
      houdbaarTot: row.houdbaarTot,
      aantal: row.aantal,
      notitie: row.notitie,
      toegevoegdOp: row.toegevoegdOp,
    );
  }
}
