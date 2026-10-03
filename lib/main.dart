import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Laadt de Nederlandse datumsymbolen zodat DateFormat('nl_NL') overal werkt.
  await initializeDateFormatting('nl_NL', null);

  runApp(
    // ProviderScope maakt Riverpod-providers beschikbaar in de hele app.
    const ProviderScope(child: App()),
  );
}
