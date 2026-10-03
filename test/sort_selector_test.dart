import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voorraadje/data/repositories/product_repository.dart';
import 'package:voorraadje/presentation/providers/product_providers.dart';
import 'package:voorraadje/presentation/widgets/sort_selector.dart';

void main() {
  testWidgets('tikken op A–Z wisselt de sorteervolgorde live', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: Center(child: SortSelector())),
        ),
      ),
    );

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SortSelector)),
    );

    // Standaard staat de lijst op houdbaarheid.
    expect(container.read(sortOrderProvider), SortOrder.houdbaarheid);

    await tester.tap(find.text('A–Z'));
    await tester.pump();
    expect(container.read(sortOrderProvider), SortOrder.alfabetisch);

    await tester.tap(find.text('Houdbaar'));
    await tester.pump();
    expect(container.read(sortOrderProvider), SortOrder.houdbaarheid);
  });
}
