import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voorraadje/data/database/app_database.dart';
import 'package:voorraadje/data/repositories/product_repository.dart';

void main() {
  late AppDatabase db;
  late ProductRepository repo;

  setUp(() {
    // In-memory database zodat elke test schoon start.
    db = AppDatabase(NativeDatabase.memory());
    repo = ProductRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('product wegschrijven en teruglezen', () async {
    await repo.addProduct(
      naam: 'Melk',
      houdbaarTot: DateTime(2026, 7, 15),
      aantal: 2,
      notitie: 'Halfvol',
    );

    final producten = await repo.watchProducts(SortOrder.alfabetisch).first;

    expect(producten, hasLength(1));
    final melk = producten.single;
    expect(melk.naam, 'Melk');
    expect(melk.aantal, 2);
    expect(melk.notitie, 'Halfvol');
    expect(melk.houdbaarTot, DateTime(2026, 7, 15));
    expect(melk.id, isPositive);
  });

  test('alfabetisch sorteren is hoofdletterongevoelig', () async {
    await repo.addProduct(naam: 'appel', houdbaarTot: DateTime(2026, 8, 1));
    await repo.addProduct(naam: 'Banaan', houdbaarTot: DateTime(2026, 8, 1));
    await repo.addProduct(naam: 'Citroen', houdbaarTot: DateTime(2026, 8, 1));

    final namen = (await repo.watchProducts(SortOrder.alfabetisch).first)
        .map((p) => p.naam)
        .toList();

    expect(namen, ['appel', 'Banaan', 'Citroen']);
  });

  test('sorteren op houdbaarheid zet vroegste datum bovenaan', () async {
    await repo.addProduct(naam: 'Laat', houdbaarTot: DateTime(2026, 12, 31));
    await repo.addProduct(naam: 'Vroeg', houdbaarTot: DateTime(2026, 7, 12));
    await repo.addProduct(naam: 'Midden', houdbaarTot: DateTime(2026, 9, 1));

    final namen = (await repo.watchProducts(SortOrder.houdbaarheid).first)
        .map((p) => p.naam)
        .toList();

    expect(namen, ['Vroeg', 'Midden', 'Laat']);
  });

  test('aantal verlagen naar 0 verwijdert het product', () async {
    final id = await repo.addProduct(
      naam: 'Eieren',
      houdbaarTot: DateTime(2026, 7, 20),
    );

    await repo.updateAantal(id, 0);

    final producten = await repo.watchProducts(SortOrder.alfabetisch).first;
    expect(producten, isEmpty);
  });

  test('verlaagAantal bij aantal 1 verwijdert het product', () async {
    await repo.addProduct(naam: 'Kaas', houdbaarTot: DateTime(2026, 7, 20));
    final product =
        (await repo.watchProducts(SortOrder.alfabetisch).first).single;

    await repo.verlaagAantal(product);

    expect(await repo.watchProducts(SortOrder.alfabetisch).first, isEmpty);
  });
}
