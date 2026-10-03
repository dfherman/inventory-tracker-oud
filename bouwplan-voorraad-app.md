# Bouwplan — Gefaseerd genereren van de Voorraad-app

Ja, dit kan prima stap voor stap. Het plan hieronder is zo opgezet dat de app **na elke fase draait en testbaar is**. Elke fase bouwt voort op de vorige zonder eerdere bestanden te hoeven herschrijven.

---

## Fase 1 — Projectskelet & thema
*Doel: een lege maar draaiende app met de juiste look.*

| # | Bestand | Inhoud |
|---|---|---|
| 1 | `pubspec.yaml` | Dependencies: flutter_riverpod, drift, sqlite3_flutter_libs, intl, google_fonts |
| 2 | `lib/main.dart` | Entrypoint met ProviderScope |
| 3 | `lib/app.dart` | MaterialApp, routes, NL-lokalisatie |
| 4 | `lib/core/theme/app_theme.dart` | Material 3-thema, licht/donker, accentkleur, typografie |

✅ **Testmoment:** app start op simulator/toestel met leeg scherm in de juiste stijl.

---

## Fase 2 — Datamodel & database
*Doel: producten kunnen opslaan en ophalen (nog zonder UI).*

| # | Bestand | Inhoud |
|---|---|---|
| 5 | `lib/domain/models/product.dart` | Product-klasse (naam, houdbaarTot, aantal, notitie) |
| 6 | `lib/data/database/app_database.dart` | Drift-tabel `products` + codegeneratie (`build_runner`) |
| 7 | `lib/data/repositories/product_repository.dart` | CRUD + `watchProducts()` met sortering (alfabet/datum) |

✅ **Testmoment:** unit-test of tijdelijke debugknop die een product wegschrijft en teruglees t.

---

## Fase 3 — Lijstpagina (lezen)
*Doel: opgeslagen producten zichtbaar maken.*

| # | Bestand | Inhoud |
|---|---|---|
| 8 | `lib/core/utils/date_formatter.dart` | Datumnotatie + houdbaarheidsstatus (verlopen/bijna/ok) |
| 9 | `lib/presentation/providers/product_providers.dart` | sortOrderProvider + productListProvider |
| 10 | `lib/presentation/widgets/product_card.dart` | Kaart met naam, datum, kleurindicator, aantal-badge |
| 11 | `lib/presentation/screens/product_list_screen.dart` | ListView, lege staat, FAB (nog zonder werkend doel) |

✅ **Testmoment:** handmatig ingevoegde testdata verschijnt correct in de lijst.

---

## Fase 4 — Registratiepagina (schrijven)
*Doel: producten toevoegen via de app zelf.*

| # | Bestand | Inhoud |
|---|---|---|
| 12 | `lib/presentation/widgets/quantity_stepper.dart` | Herbruikbare − [n] + component |
| 13 | `lib/presentation/screens/add_product_screen.dart` | Formulier: naam (verplicht), datumkiezer (verplicht), aantal; validatie + opslaan |

✅ **Testmoment:** volledig rondje — toevoegen → verschijnt in lijst → app herstarten → data blijft bewaard.

---

## Fase 5 — Sorteren & beheren
*Doel: de resterende functionele eisen afronden.*

| # | Bestand | Inhoud |
|---|---|---|
| 14 | `lib/presentation/widgets/sort_selector.dart` | Toggle A–Z ↔ houdbaarheidsdatum |
| 15 | *(aanpassing)* `product_list_screen.dart` | SortSelector in AppBar, swipe-to-delete |
| 16 | *(aanpassing)* `product_card.dart` | +/− knoppen voor aantal direct in de lijst |

✅ **Testmoment:** sorteren wisselt live; aantal verlagen naar 0 verwijdert het product.

---

## Fase 6 — Afwerking (optioneel)
- App-icoon en splashscreen
- Bevestigings-snackbars en animaties
- Widget-tests voor formuliervalidatie en sortering
- Release-configuratie voor App Store / Play Store

---

## Werkwijze per fase

1. Ik genereer de bestanden van één fase.
2. Jij plakt ze in het project en draait `flutter run` (na fase 2 eerst `dart run build_runner build`).
3. We testen het testmoment; werkt het, dan door naar de volgende fase.

Zo blijft elke stap klein, controleerbaar en makkelijk te debuggen.
