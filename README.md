# prepapp_3

## 🧱 Flavors de build

O PrepApp usa dois flavors de distribuição:

- **play**: integração com recursos da Play Store (quando aplicável).
- **fdroid**: build 100% compatível com o F-Droid (**sem** Google Play Services, Firebase/Analytics, Ads ou Play Billing).

### Como gerar a versão F-Droid (APK)
```bash
flutter clean
flutter pub get
flutter build apk --flavor fdroid --release --dart-define=FDROID=true

