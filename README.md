# campusOwl

campusOwl is a Flutter application that helps students stay organized and connected on campus. It centralizes productivity tools and community features into a single, easy-to-use mobile app.

## Why campusOwl

- Central place for notes, chats, jobs, and campus services
- Focus mode with streak tracking to boost study habits
- Light and dark theme support with simple preferences
- Offline detection and graceful handling of connectivity

## Features

- Notes with detail view and lightweight organization
- Group chat screen for campus communities
- Jobs & Services listing pages
- Focus mode with streak tracking
- Theme management via `provider`
- Offline detection screen

## Tech Stack

- Flutter (Dart)
- `provider` for state management
- `shared_preferences` for local persistence
- `google_generative_ai` (optional) for AI-driven features
- Other packages: `flutter_svg`, `carousel_slider`, `url_launcher`, `internet_connection_checker`

## Quick Start

Prerequisites:

- Install Flutter (stable channel) — https://docs.flutter.dev/get-started/install
- Set up an editor (VS Code, Android Studio, or IntelliJ)
- Android SDK / Xcode (for device builds)

Clone the repo and install dependencies:

```bash
git clone https://github.com/barshanpoddar/campusOwl-new.git
cd campusOwl-new
flutter pub get
```

Run on Android emulator or device:

```bash
flutter run -d android
```

Run on web (Chrome):

```bash
flutter run -d chrome
```

Build Android release:

```bash
flutter build apk --release
```

## Project Layout (high level)

- `lib/` — main source code
  - `main.dart` — app entry point
  - `constants.dart` — app constants
  - `providers/` — state providers (e.g., `theme_provider.dart`)
  - `screens/` — app screens (notes, jobs, chat, splash, etc.)
  - `widgets/` — reusable widgets (top bar, tab bar, FAB, dialogs)
- `assets/` — icons and images
- Platform folders: `android/`, `ios/`, `web/`, `windows/`

## Development Notes

- Theme state is handled by `lib/providers/theme_provider.dart`.
- Offline detection uses `internet_connection_checker` and shows `no_internet_screen.dart`.
- Keep `assets/icons/` updated with app icons and screenshots used in this README.

## Contributing

Contributions are welcome.

1. Fork the repo
2. Create a branch: `git checkout -b feat/my-feature`
3. Make your changes and add tests where applicable
4. Commit, push, and open a Pull Request

Please keep PRs focused and include screenshots or steps to reproduce behavior.

## Troubleshooting

- Common fixes: `flutter pub get`, `flutter clean`, then re-run
- Ensure your Flutter SDK and platform toolchains are up to date

## License

This repository does not include a license file. Add a `LICENSE` if you want to
specify reuse terms (MIT is a common, permissive choice).