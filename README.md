# PrepApp — F-Droid build

## Requisitos
- Flutter 3.24.3
- Android SDK com NDK 27.0.12077973
- Java 17

## Build local
```bash
flutter clean
flutter pub get
cd android
./gradlew clean
./gradlew :app:assembleRelease -x lint
