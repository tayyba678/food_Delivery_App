# Food Delivery App 

A modern, robust Flutter application for food delivery, featuring a modular architecture, centralized state management, and multi-platform support (Android & Web).

## 🚀 Features

### 1. Authentication & Session Management
*   **Secure Storage**: JWT tokens are encrypted on Android using Keystore and stored in IndexedDB for Chrome.
*   **Silent Token Refresh**: Automatically handles 401/403 errors by refreshing access tokens in the background.
*   **Persistent Login**: State-aware app entry that skips login for authenticated users.
*   **Centralized Logout**: Wipes local Drift database tables and clears secure tokens on session expiry or manual logout.

### 2. Modern Architecture
*   **Modular UI**: Screens are broken down into small, reusable helper functions with clear `// TODO::` documentation.
*   **State Management**: Powered by **Riverpod** for reactive and testable code.
*   **Centralized Constants**: All strings and colors are managed in `utils/` to ensure consistency and easy maintenance.

### 3. Data & Networking
*   **Local Database**: Uses **Drift (SQLite)** with conditional exports for seamless native and web compatibility.
*   **Search Engine**: Real-time search filtering across food categories.
*   **API Layer**: Integrated with `dummyjson.com` for authentication and user management.
*   **Centralized Error Handling**: A unified hub to manage Network, Timeout, Server, and Validation errors with user-friendly messages.

### 4. Firebase Integration
*   **Crashlytics**: Automatic error reporting for native platforms.
*   **Messaging (FCM)**: Push notification support configured for Android and iOS.

---

## 📂 Project Structure

```
lib/
├── api/            # API services and networking logic
├── database/       # Drift database, tables, and platform connections
├── providers/      # Riverpod state management logic
├── services/       # Business logic (Auth, Secure Storage, Sync)
├── utils/          # Strings, Colors, Error Handlers, and Keys
└── main.dart       # App entry and authentication routing
```

---

## 🛠️ Setup Instructions

### Prerequisites
*   Flutter SDK (^3.6.1)
*   Dart SDK

### Installation

1.  **Clone the repository**:
    ```bash
    git clone <https://github.com/tayyba678/food_Delivery_App>
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Generate Database Code**:
    Drift requires code generation to function. Run:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Web Support (Chrome)**:
    To run SQLite in the browser, download the required WASM binaries:
    ```bash
    dart run drift_dev download-wasm
    ```

---

## 📱 Running the App

*   **Android**: Ensure an emulator or physical device is connected.
    ```bash
    flutter run
    ```
*   **Chrome**:
    ```bash
    flutter run -d chrome
    ```

---

## 🧪 Testing the Robustness

*   **Network Error**: Turn off WiFi to see the centralized `ErrorHandler` in action.
*   **Session Expiry**: Manually expire a token to see the app automatically clear local data and redirect to the Login screen.
*   **Search**: Use the search bar on the Home screen to filter food items instantly.
