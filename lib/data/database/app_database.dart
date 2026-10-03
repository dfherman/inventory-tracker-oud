import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// De tabel `products` in de lokale SQLite-database.
///
/// Drift genereert hieruit een rij-klasse met de naam `ProductRow`
/// (via [DataClassName]) zodat die niet botst met het domeinmodel `Product`.
@DataClassName('ProductRow')
class Products extends Table {
  /// Automatisch oplopende primaire sleutel.
  IntColumn get id => integer().autoIncrement()();

  /// Naam van het product (verplicht, 1–100 tekens).
  TextColumn get naam => text().withLength(min: 1, max: 100)();

  /// Houdbaarheidsdatum.
  DateTimeColumn get houdbaarTot => dateTime()();

  /// Aantal stuks; standaard 1.
  IntColumn get aantal => integer().withDefault(const Constant(1))();

  /// Optionele notitie.
  TextColumn get notitie => text().nullable()();

  /// Tijdstip van toevoegen; standaard "nu".
  DateTimeColumn get toegevoegdOp =>
      dateTime().withDefault(currentDateAndTime)();
}

/// De Drift-database. Bevat de tabellen en de gegenereerde DAO-code.
///
/// Standaard opent hij een bestand op het toestel; voor tests kan een
/// alternatieve [QueryExecutor] worden meegegeven (bijv. een in-memory db).
@DriftDatabase(tables: [Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  /// Opent de database plaformonafhankelijk (mobiel/desktop/web).
  ///
  /// Op web moet Drift expliciet weten waar de WASM-sqlite en de web-worker
  /// staan; die bestanden zijn in `web/` geplaatst en worden vanaf de webroot
  /// geserveerd.
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'voorraadje',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
