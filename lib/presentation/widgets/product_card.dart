import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/models/product.dart';
import '../providers/product_providers.dart';
import 'quantity_stepper.dart';

/// Toont één product in de voorraadlijst: naam, houdbaarheidsdatum met
/// kleurindicator en een [QuantityStepper] om het aantal direct aan te passen
/// zonder het formulier te openen.
///
/// Verlagen tot onder 1 verwijdert het product (via de repository).
class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final status = DateFormatter.status(product.houdbaarTot);
    final statusKleur = _statusKleur(theme, status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Verticale kleurindicator die de houdbaarheidsstatus weergeeft.
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: statusKleur,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.naam,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${DateFormatter.datum(product.houdbaarTot)}  ·  '
                    '${DateFormatter.houdbaarheidLabel(product.houdbaarTot)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: statusKleur,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            QuantityStepper(
              value: product.aantal,
              // Ondergrens 0 zodat de −knop bij aantal 1 actief blijft en het
              // product dan wordt verwijderd.
              minValue: 0,
              onChanged: (nieuw) =>
                  ref.read(productRepositoryProvider).updateAantal(
                        product.id,
                        nieuw,
                      ),
            ),
          ],
        ),
      ),
    );
  }

  /// Vertaalt de houdbaarheidsstatus naar de bijbehorende themakleur.
  Color _statusKleur(ThemeData theme, Houdbaarheid status) {
    final kleuren = theme.extension<StatusColors>()!;
    switch (status) {
      case Houdbaarheid.verlopen:
        return kleuren.verlopen;
      case Houdbaarheid.bijna:
        return kleuren.bijna;
      case Houdbaarheid.ok:
        return kleuren.ok;
    }
  }
}
