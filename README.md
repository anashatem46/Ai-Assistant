# ai_assis

AI Assistant built with Flutter featuring chat, history, voice, Firebase auth, and local persistence via Hive. The app uses Provider for state management and supports mobile and web.

## Features

- Chat assistant with text and image responses
- Chat history with per‑chat message storage
- Onboarding flow and home screen (Get Started → new chat)
- Authentication via Firebase (email/Google)
- Profile and settings (dark mode, text‑to‑speech)
- Configurable API endpoint (Profile → Change API link)
- Local storage using Hive (settings, users, chat history)
- Voice support via speech‑to‑text and text‑to‑speech

## Tech Stack

- Flutter (Dart), Material Design
- State: Provider (`MultiProvider` in `lib/main.dart`)
- Persistence: Hive / Hive Flutter
- Auth/Cloud: Firebase (Auth, Firestore, Storage, Messaging)
- HTTP/config: `http`, `shared_preferences`
- Media/Voice: `image_picker`, `speech_to_text`, `flutter_tts`

## Project Structure

- `lib/` — application code
  - `main.dart` — entry with `MultiProvider` and Firebase init
  - `chat/` — chat page, input bar, API client
  - `app_page/` — home, profile, preferences, chat history
  - `auth/` — login, signup, intro
  - `providers/` — `ChatProvider`, `SettingsProvider`
  - `hive/` — models, adapters, boxes
  - `models/` — app models (e.g., `Message`)
  - `widegts/` — reusable widgets
  - `on_boarding/` — onboarding flow
- `assets/` — images and lottie animations (declared in `pubspec.yaml`)
- `test/` — Flutter tests (`*_test.dart`)
- Platform folders — `android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/`

## Getting Started

### Prerequisites

- Flutter SDK installed and on PATH
- Xcode (iOS), Android Studio/SDK (Android), or Chrome (Web)
- Optional: Firebase project configured (see Firebase Setup)

### Install dependencies

```bash
flutter pub get
```

### Run

- Mobile (default connected device): `flutter run`
- Web (Chrome): `flutter run -d chrome`

### Analyze and format

- `flutter analyze`
- `dart format .`

### Tests

- `flutter test`

## Configuration

### API Endpoint

- The app posts questions to a configurable endpoint.
- Default: see `ApiClient.defaultBaseUrl` in `lib/chat/api_config.dart`.
- To change at runtime: Profile → “Change API link” (stored in `SharedPreferences` as `api_link`).

### Environment variables & secrets

- Do not commit secrets. Prefer `--dart-define` for runtime values, e.g.:

```bash
flutter run --dart-define=API_KEY=...
```

If you add new config, read via `String.fromEnvironment(...)`.

## Firebase Setup

The app initializes Firebase in `lib/main.dart`.

- iOS: add `ios/Runner/GoogleService-Info.plist` (bundle id must match).
- Android: add `android/app/google-services.json` (applicationId must match) and apply `com.google.gms.google-services` in Gradle.
- Web: ensure Firebase web config is present (FlutterFire CLI or manual).

> Note: You can run without Firebase, but auth/cloud features will be limited.

## Development Commands

- Install deps: `flutter pub get`
- Run app: `flutter run`
- Run on web: `flutter run -d chrome`
- Analyze: `flutter analyze`
- Format: `dart format .`
- Tests: `flutter test`
- Build (examples): `flutter build apk`, `flutter build ios`, `flutter build web`

## Coding Style

- Dart style (2‑space indent, trailing commas where helpful)
- File names: `snake_case.dart` (e.g., `chat_page.dart`)
- Classes: `PascalCase`; members/methods: `lowerCamelCase`
- Widgets/pages end with `Page` or `Screen`
- Providers extend `ChangeNotifier` and live under `lib/providers/`

## Testing Guidelines

- Tests in `test/` named like `*_test.dart`
- Widget tests for UI; unit tests for logic
- Keep tests deterministic; avoid network calls

## Troubleshooting

- Hive adapters: ensure adapters are registered before opening boxes (see `ChatProvider.initHive()`).
- Microphone/Speech: confirm platform permissions on Android/iOS.
- API connectivity: verify the “Change API link” value and server reachability.
