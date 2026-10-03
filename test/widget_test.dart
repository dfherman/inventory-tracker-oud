import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:voorraadje/app.dart';
import 'package:voorraadje/domain/models/product.dart';
import 'package:voorraadje/presentation/providers/product_providers.dart';

void main() {
  setUpAll(() async {
    // Nederlandse datumsymbolen laden zodat de kaart datums kan formatteren.
    await initializeDateFormatting('nl_NL', null);
  });

  testWidgets('lege voorraad toont de lege staat', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Deterministische lege lijst i.p.v. de echte Drift-stream; de
          // databaselogica is al gedekt in product_repository_test.dart.
          productListProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: const App(),
      ),
    );
    // Twee frames: eerst het laadframe, dan levert de stream de lege lijst.
    await tester.pump();
    await tester.pump();

    expect(find.text('Voorraadje'), findsWidgets);
    expect(find.text('Nog geen producten'), findsOneWidget);
  });

  testWidgets('opgeslagen product verschijnt in de lijst', (tester) async {
    final melk = Product(
      id: 1,
      naam: 'Melk',
      houdbaarTot: DateTime(2026, 7, 15),
      toegevoegdOp: DateTime(2026, 7, 10),
      aantal: 2,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productListProvider.overrideWith((ref) => Stream.value([melk])),
        ],
        child: const App(),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Melk'), findsOneWidget);
    // Het aantal staat nu in de QuantityStepper op de kaart.
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Nog geen producten'), findsNothing);
  });
}
