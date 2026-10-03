# Architectuur — Voorraad-app (werktitel: "Voorraadje")

## 1. Technologiekeuze

**Framework: Flutter** — één codebase voor iOS én Android, uitstekende performance, en met Material 3 krijg je vrijwel gratis een moderne, minimalistische look. (Alternatief: React Native, maar Flutter geeft consistentere UI op beide platforms.)

**Lokale opslag: Drift (SQLite)** — de data blijft op het toestel, werkt offline, en Drift geeft type-veilige queries met reactieve streams (de lijst ververst automatisch bij wijzigingen). Voor deze omvang is geen backend/server nodig.

**State management: Riverpod** — lichtgewicht, testbaar, en koppelt de database-streams eenvoudig aan de UI.

## 2. Gelaagde architectuur

```
┌─────────────────────────────┐
│  Presentation (UI)          │  Schermen, widgets, providers
├─────────────────────────────┤
│  Domain                     │  Product-model, sorteerlogica
├─────────────────────────────┤
│  Data                       │  Drift-database, repository
└─────────────────────────────┘
```

De UI praat nooit rechtstreeks met de database, maar altijd via de repository. Zo kun je later eenvoudig een cloud-sync of barcodescanner toevoegen zonder de schermen te herschrijven.

## 3. Mappenstructuur en inhoud per file

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/app_theme.dart
│   └── utils/date_formatter.dart
├── data/
│   ├── database/app_database.dart
│   └── repositories/product_repository.dart
├── domain/
│   └── models/product.dart
└── presentation/
    ├── providers/product_providers.dart
    ├── screens/
    │   ├── product_list_screen.dart
    │   └── add_product_screen.dart
    └── widgets/
        ├── product_card.dart
        ├── quantity_stepper.dart
        └── sort_selector.dart
```

### main.dart
Entrypoint. Initialiseert de database, wikkelt de app in een `ProviderScope` (Riverpod) en start `App`.

### app.dart
De `MaterialApp`: routes (`/` → lijst, `/add` → registratie), thema-koppeling, Nederlandse lokalisatie (voor datumnotatie dd-mm-jjjj).

### core/theme/app_theme.dart
Het minimalistische design op één plek:
- Material 3, veel witruimte, één accentkleur (bijv. zachtgroen)
- Lichte én donkere variant
- Afgeronde kaarten zonder zware schaduwen, rustige typografie (bijv. Inter)
- Semantische kleuren voor houdbaarheid: rood = verlopen, oranje = < 3 dagen, neutraal = ok

### core/utils/date_formatter.dart
Hulpfuncties: datum formatteren ("12 jul 2026"), dagen tot verlopen berekenen, en de status (verlopen / bijna / ok) bepalen. Eén plek, zodat lijst en kaart dezelfde logica gebruiken.

### domain/models/product.dart
Het kern-datamodel:

```dart
class Product {
  final int id;
  final String naam;            // verplicht
  final DateTime houdbaarTot;   // verplicht
  final int aantal;             // default 1 — jouw "meerdere van hetzelfde"
  final String? notitie;        // optioneel
  final DateTime toegevoegdOp;
}
```

### data/database/app_database.dart
Drift-definitie van de tabel `products` (kolommen zoals hierboven) plus migratielogica. Genereert automatisch de DAO-code.

### data/repositories/product_repository.dart
De enige toegangspoort tot data:
- `watchProducts(SortOrder order)` → stream van producten, gesorteerd op **alfabet** of **houdbaarheidsdatum** (sorteren gebeurt hier, in de query)
- `addProduct(...)`, `updateAantal(id, aantal)`, `deleteProduct(id)`
- Verlaag-aantal-logica: bij aantal 1 → verwijderen, anders aantal − 1

### presentation/providers/product_providers.dart
Riverpod-providers:
- `sortOrderProvider` — huidige sortering (alfabet ↔ datum)
- `productListProvider` — combineert sortering + repository-stream; de UI luistert hierop en ververst live

### presentation/screens/product_list_screen.dart
**Pagina 1: de voorraadlijst.**
- AppBar met titel en `SortSelector`
- `ListView` van `ProductCard`s
- Swipe-to-delete, lege-staat-illustratie ("Nog geen producten")
- FloatingActionButton (+) → registratiescherm

### presentation/screens/add_product_screen.dart
**Pagina 2: registratie.**
- Tekstveld **naam** (verplicht, validatie)
- Datumkiezer **houdbaarheidsdatum** (verplicht)
- `QuantityStepper` voor **aantal** (default 1)
- Opslaan-knop → repository → terug naar lijst met bevestiging (snackbar)

### presentation/widgets/product_card.dart
Eén product in de lijst: naam, houdbaarheidsdatum met kleurindicator, badge "×3" bij meerdere stuks, en +/− knoppen om het aantal aan te passen zonder het formulier te openen.

### presentation/widgets/quantity_stepper.dart
Herbruikbare − [aantal] + component, gebruikt in formulier én kaart.

### presentation/widgets/sort_selector.dart
Segmented button of dropdown: "A–Z" ↔ "Houdbaarheid". Schrijft naar `sortOrderProvider`.

## 4. Datastroom (voorbeeld: product toevoegen)

```
AddProductScreen → repository.addProduct()
      → Drift schrijft naar SQLite
      → watchProducts-stream zendt nieuwe lijst uit
      → productListProvider update
      → ProductListScreen herbouwt automatisch
```

## 5. Latere uitbreidingen (past in deze architectuur)

- **Notificaties** bij bijna-verlopen producten (`flutter_local_notifications`) → nieuwe service in `core/`
- **Barcodescanner** voor snelle registratie → extra veld + scanner-widget
- **Categorieën/locaties** (koelkast, vriezer, kast) → extra kolom + filter-provider
- **Cloud-sync** → tweede repository-implementatie achter dezelfde interface

## 6. Belangrijkste dependencies (pubspec.yaml)

| Package | Doel |
|---|---|
| `flutter_riverpod` | State management |
| `drift` + `sqlite3_flutter_libs` | Lokale database |
| `intl` | Nederlandse datumnotatie |
| `google_fonts` | Typografie (Inter) |
