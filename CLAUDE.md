# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**basketapp** is a Flutter mobile application targeting iOS and Android platforms. It uses Material Design and is built with Dart 3.11.5+.

## Essential Commands

### Setup & Dependencies
```bash
flutter pub get                    # Install dependencies
flutter pub upgrade                # Upgrade all dependencies
flutter pub outdated               # Check for outdated packages
```

### Development & Running
```bash
flutter run                        # Run the app on connected device/emulator
flutter run -d <device-id>         # Run on a specific device
flutter run --release              # Build and run in release mode
flutter run --profile              # Build and run in profile mode (for performance analysis)
```

### Testing
```bash
flutter test                       # Run all widget tests
flutter test test/widget_test.dart # Run a specific test file
flutter test --coverage            # Run tests with coverage report
```

### Code Quality
```bash
flutter analyze                    # Run dart analyzer for lint warnings
dart format lib/                   # Auto-format Dart files
dart fix --apply                   # Apply automated lint fixes
```

### Building
```bash
flutter build apk                  # Build Android APK
flutter build ios                  # Build iOS app
flutter build web                  # Build web version (if enabled)
flutter clean                      # Clean build artifacts
```

## Project Structure

- **lib/** - Main Flutter application code
  - `main.dart` - Entry point; defines MaterialApp and root widgets
  - Widget files organized by feature (to be expanded as the app grows)
- **test/** - Widget and unit tests
  - `widget_test.dart` - Example widget test using WidgetTester
- **android/** - Android platform-specific code and configuration
- **ios/** - iOS platform-specific code and configuration
- **pubspec.yaml** - Project manifest with dependencies and Flutter configuration
- **analysis_options.yaml** - Dart analyzer and linter configuration (uses flutter_lints)

## Code Style & Linting

- This project uses **flutter_lints** for recommended lint rules (configured in `analysis_options.yaml`)
- Run `flutter analyze` before committing to catch lint violations
- Dart code should follow standard Flutter naming conventions:
  - Classes: PascalCase
  - Variables/functions: camelCase
  - Constants: camelCase
  - Private members: prefix with underscore
- Use `dart format` for consistent formatting (2-space indentation is standard)

## Architecture Notes

- **Material Design**: The app uses Material Design theme with deep purple seed color. Customize `ThemeData` in `main.dart` for branding.
- **Widget-based**: Everything in Flutter is a widget. Stateless widgets for static content, StatefulWidget for state changes.
- **State Management**: Currently uses simple `setState()` for state management. As the app grows, consider:
  - Provider for simple to medium complexity
  - Riverpod or GetX for more advanced patterns
  - BLoC for larger applications

## Testing Strategy

- Use **flutter_test** package for widget and integration tests
- Widget tests use `WidgetTester` to pump widgets, simulate user interactions, and verify state
- Tests live in `test/` directory and should mirror `lib/` structure
- Run tests frequently during development with `flutter test`

## Performance & Debugging

- Use `flutter run --profile` to identify performance bottlenecks
- DevTools: `flutter pub global activate devtools && devtools` opens web-based debugging UI
- Check logs during development: `flutter logs`

## Platform-Specific Notes

- **iOS**: Check `ios/Podfile` and `ios/Runner/Info.plist` for configuration
- **Android**: Check `android/app/build.gradle` and `AndroidManifest.xml` for configuration
- Minimum SDK versions are set in build files (Android) and Podfile (iOS)

## Common Gotchas

- Hot reload may not work when changing code that affects app-level state; use hot restart with `r`
- Widget rebuilds are triggered by `setState()` or provider updates—ensure state changes are properly triggered
- Plugin compatibility varies between iOS and Android; check pubspec.yaml dependency comments
