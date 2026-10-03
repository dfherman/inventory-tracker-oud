import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/product_repository.dart';
import '../providers/product_providers.dart';

/// Segmented button om te wisselen tussen sorteren op naam (A–Z) en op
/// houdbaarheidsdatum. Schrijft naar [sortOrderProvider]; de lijst beweegt
/// live mee.
class SortSelector extends ConsumerWidget {
  const SortSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(sortOrderProvider);

    return SegmentedButton<SortOrder>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(
          value: SortOrder.alfabetisch,
          icon: Icon(Icons.sort_by_alpha),
          label: Text('A–Z'),
        ),
        ButtonSegment(
          value: SortOrder.houdbaarheid,
          icon: Icon(Icons.schedule),
          label: Text('Houdbaar'),
        ),
      ],
      selected: {order},
      onSelectionChanged: (selectie) {
        ref.read(sortOrderProvider.notifier).set(selectie.first);
      },
    );
  }
}
