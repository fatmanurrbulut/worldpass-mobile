# WorldPass Mobile

WorldPass Mobile is a cross-platform Flutter application designed to provide a seamless digital wallet experience. The app enables users to manage credentials, verify identities, and interact securely with issuers and verifiers. Built with a modular architecture, WorldPass Mobile supports Android, iOS, Web, Windows, macOS, and Linux.

## Features

- **Authentication:** Secure login and registration flows.
- **Wallet:** Store, manage, and present digital credentials.
- **Verification:** Scan and verify credentials using QR codes or other methods.
- **Issuer Integration:** Request and receive credentials from trusted issuers.
- **User Settings:** Manage account preferences and app settings.
- **Multi-Platform Support:** Runs on mobile, desktop, and web.

## Project Structure

- `lib/` - Main Dart source code
	- `core/` - Core models and routing
	- `features/` - Feature modules (auth, home, issuer, present, settings, splash, verify, wallet)
	- `ui/` - UI components and theme
- `test/` - Unit and widget tests
- `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` - Platform-specific code

## Getting Started

1. **Clone the repository:**
	 ```sh
	 git clone <your-repo-url>
	 cd worldpass-mobile
	 ```
2. **Install dependencies:**
	 ```sh
	 flutter pub get
	 ```
3. **Run the app:**
	 - For mobile:
		 ```sh
		 flutter run
		 ```
	 - For web:
		 ```sh
		 flutter run -d chrome
		 ```
	 - For desktop (Windows/macOS/Linux):
		 ```sh
		 flutter run -d windows # or macos/linux
		 ```

## Requirements

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart 3.x
- Android Studio/Xcode/VS Code (for platform-specific builds)

## Contributing

Contributions are welcome! Please open issues or submit pull requests for improvements and bug fixes.

## License

This project is licensed under the MIT License.

---
For more information, see the [Flutter documentation](https://docs.flutter.dev/).
