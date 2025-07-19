# Stock Alert App

A Flutter application for monitoring stock prices and receiving alerts.

## Overview

This app allows users to track stock prices and set alerts for specific price points. When a stock reaches the alert price, the user is notified.

## Features

- View a list of stocks with current prices.
- Set alerts for specific stocks.
- Receive notifications when stock prices hit alert thresholds.
- Simple and intuitive user interface.

## Getting Started

### Prerequisites

- Flutter SDK installed. See [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- An IDE such as Android Studio, VS Code, or IntelliJ IDEA.

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/ananyaudupa/stock_alert_app.git
   ```
2. Navigate to the project directory:
   ```
   cd stock_alert_app
   ```
3. Get the dependencies:
   ```
   flutter pub get
   ```
4. Run the app:
   ```
   flutter run
   ```

## Project Structure

- `lib/main.dart`: Entry point of the application.
- `lib/screens/alert_screen.dart`: Screen to view and manage stock alerts.
- `lib/models/stock_alert.dart`: Data model for stock alerts.
- `lib/services/stock_service.dart`: Service for fetching stock data.

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

## License

This project is licensed under the MIT License.
