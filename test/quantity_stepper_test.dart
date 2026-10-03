import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voorraadje/presentation/widgets/quantity_stepper.dart';

/// Pompt de stepper met een lokale staat zodat + en − het getal echt wijzigen.
Widget _harnas({int start = 1, int minValue = 1}) {
  return MaterialApp(
    home: Scaffold(
      body: _StepperHost(start: start, minValue: minValue),
    ),
  );
}

class _StepperHost extends StatefulWidget {
  const _StepperHost({required this.start, required this.minValue});
  final int start;
  final int minValue;

  @override
  State<_StepperHost> createState() => _StepperHostState();
}

class _StepperHostState extends State<_StepperHost> {
  late int _value = widget.start;

  @override
  Widget build(BuildContext context) {
    return QuantityStepper(
      value: _value,
      minValue: widget.minValue,
      onChanged: (nieuw) => setState(() => _value = nieuw),
    );
  }
}

void main() {
  testWidgets('plus verhoogt en min verlaagt het aantal', (tester) async {
    await tester.pumpWidget(_harnas(start: 1));

    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('min is uitgeschakeld op de ondergrens', (tester) async {
    await tester.pumpWidget(_harnas(start: 1, minValue: 1));

    final minKnop = tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.remove),
        matching: find.byType(IconButton),
      ),
    );
    expect(minKnop.onPressed, isNull);
  });
}
