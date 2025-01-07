# Users List Flutter App

This Flutter application fetches and displays a list of users from a remote API. It demonstrates the use of state management with Provider, network requests with the `http` package, and UI components with Flutter's Material Design.

## Features

- Fetches user data from a remote API.
- Displays user information in a list with avatars, names, and emails.
- Implements light and dark themes with a toggle button.
- Provides a search functionality to filter users by name or email.
- Handles loading and error states gracefully.
- Uses a `Skeletonizer` for loading animations.

## Folder Structure

lib/
│
├── main.dart # Entry point of the application
│
├── models/
│ └── user.dart # User model class
│
├── providers/
│ └── user_provider.dart # State management for user data
│
├── services/
│ └── api_client.dart # API client for network requests
│
├── views/
│ ├── screens/
│ │ └── home_screen.dart # Main screen displaying the user list
│ │
│ └── widgets/
│ ├── user_list_item.dart # Widget for displaying individual user items
│ └── empty_state.dart # Widget for displaying empty/error states
│
└── pubspec.yaml # Project configuration and dependencies

## Dependencies

- **Flutter SDK**: The core framework for building the app.
- **Provider**: State management solution.
- **HTTP**: For making network requests.
- **Cached Network Image**: For efficient image loading and caching.
- **Skeletonizer**: For displaying loading animations.
- **Flutter Animate**: For adding animations to UI components.

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Included with Flutter

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/tonyaneke/users_list.git
   cd users_list
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Testing

The application includes a comprehensive test suite covering various components:

### Unit and Widget Tests

- **EmptyState Widget Tests**: Verifies the empty state widget displays correct information and action buttons
- **Theme Controller Tests**: Ensures proper functionality of theme switching between light and dark modes
- **User List Item Tests**: Validates the correct display of user information in list items
- **User Provider Tests**: Tests the state management logic including:
  - Initial state validation
  - User data fetching
  - Search/filtering functionality
  - Error handling

### Running Tests

To run all tests:

```bash
flutter test
```

To run a specific test file:

```bash
flutter test test/user_provider_test.dart
```

## Continuous Integration/Continuous Deployment (CI/CD)

[![Flutter CI/CD](https://github.com/{username}/{repo}/actions/workflows/flutter_ci_cd.yml/badge.svg)](https://github.com/{username}/{repo}/actions/workflows/flutter_ci_cd.yml)

This project uses GitHub Actions for automated testing, building, and deployment. The CI/CD pipeline includes:

### Automated Workflows

1. **Build and Test**

   - Code formatting verification
   - Static code analysis
   - Unit and widget tests execution
   - Test coverage reporting

2. **Build Pipeline**

   - Android APK generation
   - iOS build verification
   - Artifact storage for deployment

3. **Deployment Stages**

   - **Staging** (develop branch)

     - Automated deployment to Firebase App Distribution
     - Available to registered testers

   - **Production** (main branch)
     - Automated deployment to Google Play Store
     - Production track release

### Workflow Triggers

- Push to `main` branches
- Pull requests to `main` branches

### Required Secrets

The following secrets need to be configured in GitHub repository settings:

- `FIREBASE_APP_ID`: Firebase application identifier
- `CREDENTIAL_FILE_CONTENT`: Firebase service account credentials
- `SERVICE_ACCOUNT_JSON`: Google Play Console service account

### Quality Checks

- Dart code formatting
- Flutter static analysis
- Automated tests with coverage
- Build verification for both platforms

### Build Artifacts

- Android: Release APK
- iOS: Release build (unsigned)

For detailed workflow configuration, see `.github/workflows/flutter_ci_cd.yml`
