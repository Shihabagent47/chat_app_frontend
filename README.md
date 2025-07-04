# Chat App User

A modern, cross-platform chat application frontend built with Flutter.

## Features

- Real-time messaging
- User authentication
- Group and private chats
- Media sharing (images, files)
- Push notifications
- Responsive UI for mobile, web, and desktop

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart
- Android Studio or Xcode (for mobile development)
- A backend server (not included in this repo)

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/chat_app_frontend.git
   cd chat_app_frontend
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

### Running with Flavors (Environments)

This project supports multiple environments (flavors): **development**, **staging**, and **production**. Each environment has its own main entrypoint.

To run the app in a specific environment, use the `--target` option with `flutter run`:

- **Development**
  ```sh
  flutter run --target=lib/main_development.dart
  ```
- **Staging**
  ```sh
  flutter run --target=lib/main_staging.dart
  ```
- **Production**
  ```sh
  flutter run --target=lib/main_production.dart
  ```

You can use these commands for all supported platforms (Android, iOS, web, desktop). For example, to run the production flavor on web:

```sh
flutter run -d chrome --target=lib/main_production.dart
```

> **Note:** Make sure to use the correct device flag (`-d`) for your target platform.

## Project Structure

- `lib/` - Main Dart source code
- `android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/` - Platform-specific code
- `test/` - Unit and widget tests

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](LICENSE)
