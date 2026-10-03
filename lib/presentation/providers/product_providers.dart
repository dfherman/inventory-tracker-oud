import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/models/product.dart';

/// De gedeelde databaseverbinding. Wordt eenmalig geopend en netjes gesloten
/// wanneer de provider wordt weggegooid.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// De enige toegangspoort tot de productdata (zie architectuur: de UI praat
/// nooit rechtstreeks met de database).
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(databaseProvider));
});

/// De actieve sorteervolgorde van de lijst. Het sorteermenu (Fase 5) schrijft
/// hiernaartoe; de lijst leest ervan en ververst live.
final sortOrderProvider =
    NotifierProvider<SortOrderNotifier, SortOrder>(SortOrderNotifier.new);

/// Beheert de gekozen [SortOrder]. Start op houdbaarheid zodat producten die
/// het eerst verlopen bovenaan staan.
class SortOrderNotifier extends Notifier<SortOrder> {
  @override
  SortOrder build() => SortOrder.houdbaarheid;

  /// Kiest een nieuwe sorteervolgorde.
  void set(SortOrder order) => state = order;
}

/// De reactieve voorraadlijst: combineert de gekozen sortering met de
/// repository-stream. De UI luistert hierop en herbouwt automatisch bij elke
/// wijziging in de database of de sortering.
final productListProvider = StreamProvider<List<Product>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  final order = ref.watch(sortOrderProvider);
  return repository.watchProducts(order);
});
