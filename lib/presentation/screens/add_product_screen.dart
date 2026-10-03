import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_formatter.dart';
import '../providers/product_providers.dart';
import '../widgets/quantity_stepper.dart';

/// Pagina 2: registratie van een nieuw product.
///
/// Bevat een naamveld (verplicht), een datumkiezer (verplicht), een
/// [QuantityStepper] voor het aantal en een optionele notitie. Bij opslaan
/// keert het scherm terug naar de lijst met de productnaam als resultaat,
/// zodat de lijst een bevestigings-snackbar kan tonen.
class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _naamController = TextEditingController();
  final _notitieController = TextEditingController();

  DateTime? _houdbaarTot;
  int _aantal = 1;
  bool _bezig = false;

  @override
  void dispose() {
    _naamController.dispose();
    _notitieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nieuw product')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            TextFormField(
              controller: _naamController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Naam',
                hintText: 'Bijv. Melk',
              ),
              validator: (waarde) {
                if (waarde == null || waarde.trim().isEmpty) {
                  return 'Vul een naam in';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _DatumVeld(
              datum: _houdbaarTot,
              onKies: _kiesDatum,
            ),
            const SizedBox(height: 24),
            Text('Aantal', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                QuantityStepper(
                  value: _aantal,
                  onChanged: (nieuw) => setState(() => _aantal = nieuw),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _notitieController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Notitie (optioneel)',
                hintText: 'Bijv. halfvol, in de vriezer',
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _bezig ? null : _opslaan,
              icon: _bezig
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: const Text('Opslaan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _kiesDatum() async {
    final nu = DateTime.now();
    final gekozen = await showDatePicker(
      context: context,
      initialDate: _houdbaarTot ?? nu,
      // Sta ook net-verlopen producten toe, tot tien jaar vooruit.
      firstDate: DateTime(nu.year - 1),
      lastDate: DateTime(nu.year + 10),
      helpText: 'Kies houdbaarheidsdatum',
    );
    if (gekozen != null) {
      setState(() => _houdbaarTot = gekozen);
    }
  }

  Future<void> _opslaan() async {
    final formGeldig = _formKey.currentState?.validate() ?? false;
    if (!formGeldig) return;

    if (_houdbaarTot == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Kies een houdbaarheidsdatum')),
        );
      return;
    }

    setState(() => _bezig = true);

    final naam = _naamController.text.trim();
    final notitie = _notitieController.text.trim();

    await ref.read(productRepositoryProvider).addProduct(
          naam: naam,
          houdbaarTot: _houdbaarTot!,
          aantal: _aantal,
          notitie: notitie.isEmpty ? null : notitie,
        );

    if (!mounted) return;
    Navigator.of(context).pop(naam);
  }
}

/// Tikbaar veld dat de gekozen houdbaarheidsdatum toont (of een uitnodiging).
class _DatumVeld extends StatelessWidget {
  const _DatumVeld({required this.datum, required this.onKies});

  final DateTime? datum;
  final VoidCallback onKies;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gekozen = datum != null;

    return InkWell(
      onTap: onKies,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Houdbaar tot',
        ),
        child: Row(
          children: [
            Icon(
              Icons.event_outlined,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              gekozen ? DateFormatter.datum(datum!) : 'Kies een datum',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: gekozen
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
