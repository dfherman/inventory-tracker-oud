import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voorraadje/presentation/screens/add_product_screen.dart';

Widget _host() {
  return const ProviderScope(
    child: MaterialApp(home: AddProductScreen()),
  );
}

void main() {
  testWidgets('lege naam blokkeert opslaan', (tester) async {
    await tester.pumpWidget(_host());

    await tester.tap(find.text('Opslaan'));
    await tester.pump();

    expect(find.text('Vul een naam in'), findsOneWidget);
  });

  testWidgets('zonder houdbaarheidsdatum verschijnt een melding',
      (tester) async {
    await tester.pumpWidget(_host());

    await tester.enterText(find.byType(TextFormField).first, 'Melk');
    await tester.tap(find.text('Opslaan'));
    await tester.pump(); // laat de snackbar verschijnen

    expect(find.text('Vul een naam in'), findsNothing);
    expect(find.text('Kies een houdbaarheidsdatum'), findsOneWidget);
  });
}
