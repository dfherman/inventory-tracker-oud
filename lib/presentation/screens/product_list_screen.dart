import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/product.dart';
import '../providers/product_providers.dart';
import '../widgets/product_card.dart';
import '../widgets/sort_selector.dart';
import 'add_product_screen.dart';

/// Pagina 1: de voorraadlijst.
///
/// Luistert op [productListProvider] en herbouwt automatisch wanneer de
/// database of de sortering verandert. Toont een lege staat als er nog geen
/// producten zijn.
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productenAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voorraadje'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SortSelector(),
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: productenAsync.when(
          data: (producten) => producten.isEmpty
              ? const _LegeStaat(key: ValueKey('leeg'))
              : _ProductLijst(
                  key: const ValueKey('lijst'),
                  producten: producten,
                ),
          loading: () => const Center(
            key: ValueKey('laden'),
            child: CircularProgressIndicator(),
          ),
          error: (fout, _) => _Foutstaat(key: const ValueKey('fout'), fout: fout),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _naarRegistratie(context),
        tooltip: 'Product toevoegen',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Opent het registratiescherm en toont een bevestiging als er iets is
  /// opgeslagen. De lijst zelf ververst automatisch via de stream.
  Future<void> _naarRegistratie(BuildContext context) async {
    final naam = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const AddProductScreen()),
    );
    if (naam == null || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text("'$naam' toegevoegd")),
      );
  }
}

/// De scrolbare lijst met productkaarten, elk met swipe-to-delete.
class _ProductLijst extends ConsumerWidget {
  const _ProductLijst({super.key, required this.producten});

  final List<Product> producten;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: producten.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final product = producten[index];
        return Dismissible(
          key: ValueKey(product.id),
          direction: DismissDirection.endToStart,
          background: _VerwijderAchtergrond(),
          onDismissed: (_) => _verwijder(context, ref, product),
          child: ProductCard(product: product),
        );
      },
    );
  }

  /// Verwijdert het product en biedt via een snackbar de kans het terug te
  /// zetten (opnieuw toevoegen met dezelfde gegevens).
  void _verwijder(BuildContext context, WidgetRef ref, Product product) {
    final repository = ref.read(productRepositoryProvider);
    repository.deleteProduct(product.id);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text("'${product.naam}' verwijderd"),
          action: SnackBarAction(
            label: 'Ongedaan maken',
            onPressed: () => repository.addProduct(
              naam: product.naam,
              houdbaarTot: product.houdbaarTot,
              aantal: product.aantal,
              notitie: product.notitie,
            ),
          ),
        ),
      );
  }
}

/// De rode achtergrond met prullenbak-icoon die achter de kaart verschijnt
/// tijdens het wegvegen.
class _VerwijderAchtergrond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.delete_outline,
        color: theme.colorScheme.onErrorContainer,
      ),
    );
  }
}

/// Illustratie + tekst wanneer de voorraad nog leeg is.
class _LegeStaat extends StatelessWidget {
  const _LegeStaat({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Nog geen producten',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Voeg je eerste product toe met de +-knop.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nette foutmelding als de stream onverhoopt faalt.
class _Foutstaat extends StatelessWidget {
  const _Foutstaat({super.key, required this.fout});

  final Object fout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Kon de voorraad niet laden',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '$fout',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
