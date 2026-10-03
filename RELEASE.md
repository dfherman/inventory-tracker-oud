# Release-handleiding — Voorraadje

Deze app draait en is testbaar op web (Chrome), Android en Windows. Hieronder
staan de stappen om een **release-build** te maken en te publiceren. De code is
klaar; de onderstaande handmatige stappen (keystore, store-accounts) moet je
zelf uitvoeren.

## 1. Versie ophogen

De versie staat in `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

- `1.0.0` = versienaam (zichtbaar in de store).
- `+1` = buildnummer (moet bij elke store-upload omhoog).

Verhoog dit vóór elke nieuwe upload, bijv. `1.0.1+2`.

## 2. App-identiteit

- **Android applicationId:** `com.voorraadje.voorraadje`
  (in `android/app/build.gradle.kts`). Dit is de definitieve, unieke id in de
  Play Store — wijzig 'm nu, niet na de eerste publicatie.
- **Naam & icoon:** het icoon is gegenereerd met `flutter_launcher_icons`
  (bron: `assets/icon/icon.png`). Splash via `flutter_native_splash`
  (`assets/icon/splash.png`). Na een ontwerpwijziging:

  ```bash
  dart run tool/generate_icon.dart          # herteken de bron-PNG's
  dart run flutter_launcher_icons           # verwerk naar platformmappen
  dart run flutter_native_splash:create     # idem voor de splash
  ```

## 3. Android — release ondertekenen

De release gebruikt nu tijdelijk de **debug-sleutel** (zie de `release`-block in
`android/app/build.gradle.kts`). Voor publicatie heb je een eigen keystore nodig.

1. Maak een keystore aan (bewaar dit bestand én de wachtwoorden veilig; kwijt =
   je kunt geen updates meer publiceren):

   ```bash
   keytool -genkey -v -keystore %USERPROFILE%\voorraadje-upload.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Maak `android/key.properties` (voeg dit bestand toe aan `.gitignore` — nooit
   committen):

   ```properties
   storePassword=<wachtwoord>
   keyPassword=<wachtwoord>
   keyAlias=upload
   storeFile=C:/Users/<jij>/voorraadje-upload.jks
   ```

3. Koppel de keystore in `android/app/build.gradle.kts`. Bovenaan (vóór
   `android { ... }`) de properties inlezen:

   ```kotlin
   import java.util.Properties
   import java.io.FileInputStream

   val keystoreProperties = Properties()
   val keystorePropertiesFile = rootProject.file("key.properties")
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(FileInputStream(keystorePropertiesFile))
   }
   ```

   Binnen `android { ... }` een `signingConfigs`-block toevoegen en de
   `release`-buildtype ernaar laten wijzen:

   ```kotlin
   signingConfigs {
       create("release") {
           keyAlias = keystoreProperties["keyAlias"] as String
           keyPassword = keystoreProperties["keyPassword"] as String
           storeFile = keystoreProperties["storeFile"]?.let { file(it) }
           storePassword = keystoreProperties["storePassword"] as String
       }
   }
   buildTypes {
       release {
           signingConfig = signingConfigs.getByName("release")
       }
   }
   ```

4. Bouw het App Bundle (aanbevolen voor de Play Store):

   ```bash
   flutter build appbundle --release
   # resultaat: build/app/outputs/bundle/release/app-release.aab
   ```

   Of een los installeerbare APK: `flutter build apk --release`.

## 4. iOS (optioneel, vereist macOS)

Er is nog geen `ios/`-map. Genereer die eerst op een Mac:

```bash
flutter create --platforms=ios .
```

Daarna signing regelen in Xcode (Apple Developer-account nodig) en bouwen met
`flutter build ipa --release`.

## 5. Web

```bash
flutter build web --release
# resultaat: build/web/  (statisch te hosten)
```

De Drift-webbestanden (`web/sqlite3.wasm`, `web/drift_worker.js`) worden
meegenomen in de build.

## 6. Windows

```bash
flutter build windows --release
```

Vereist de "Desktop development with C++"-workload van Visual Studio.

## Checklist vóór publicatie

- [ ] Versie + buildnummer opgehoogd
- [ ] Release-signing ingesteld (Android) / provisioning (iOS)
- [ ] `flutter analyze` schoon en `flutter test` groen
- [ ] Getest op een echt toestel in release-modus
- [ ] Store-vermelding: schermafbeeldingen, beschrijving, privacybeleid
