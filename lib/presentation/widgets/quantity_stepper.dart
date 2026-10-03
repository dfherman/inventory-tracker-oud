import 'package:flutter/material.dart';

/// Herbruikbare − [aantal] + component om een geheel getal aan te passen.
///
/// Wordt gebruikt in het registratieformulier en (vanaf Fase 5) op de
/// productkaart. De widget houdt zelf geen staat bij: hij toont [value] en
/// meldt wijzigingen via [onChanged].
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.minValue = 1,
    this.maxValue = 999,
  });

  /// Het huidige aantal.
  final int value;

  /// Wordt aangeroepen met het nieuwe aantal na een + of − tik.
  final ValueChanged<int> onChanged;

  /// Ondergrens; de −knop is uitgeschakeld op deze waarde.
  final int minValue;

  /// Bovengrens; de +knop is uitgeschakeld op deze waarde.
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final kanOmlaag = value > minValue;
    final kanOmhoog = value < maxValue;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: kanOmlaag ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove),
            tooltip: 'Minder',
          ),
          // Vaste breedte zodat het getal niet verspringt bij 1 → 10 → 100.
          SizedBox(
            width: 40,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: kanOmhoog ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add),
            tooltip: 'Meer',
          ),
        ],
      ),
    );
  }
}
