# Finance Loan Mobile Application

A comprehensive Flutter mobile application that allows customers to request finance loans from banks to purchase products from contracted companies. The app supports three languages (English, Arabic, and Kurdish) and provides real-time transaction tracking.

## Features

### Core Functionality
- **User Authentication**: Secure login system with persistent sessions
- **Multi-language Support**: English, Arabic, and Kurdish with RTL support
- **Loan Management**: Request loans from multiple banks
- **Credit Limits**: Individual credit limits per bank-company combination
- **Transaction Tracking**: Real-time status updates for all loan requests
- **Dashboard Analytics**: Overview of pending and approved loans

### Technical Features
- **State Management**: Provider pattern for efficient state management
- **Secure Storage**: Encrypted storage for sensitive data
- **RESTful API**: Full HTTP client integration
- **Responsive Design**: Adaptive layouts for all screen sizes
- **Offline Support**: Cached data for better user experience

## Architecture

### Project Structure
```
flutter_finance_loan_app/
├── android/                 # Android platform files
├── ios/                     # iOS platform files  
├── web/                     # Web platform files
├── assets/                  # App assets
│   ├── images/              # Image assets
│   ├── icons/               # Icon assets
│   └── translations/        # Translation JSON files
│       ├── en.json          # English translations
│       ├── ar.json          # Arabic translations
│       └── ku.json          # Kurdish translations
├── fonts/                   # Custom fonts
├── lib/                     # Dart source code
│   ├── main.dart            # Application entry point
│   └── src/
│       ├── constants/       # App constants and configuration
│       ├── models/          # Data models
│       │   ├── user_model.dart
│       │   ├── bank_model.dart
│       │   ├── company_model.dart
│       │   ├── loan_model.dart
│       │   └── credit_limit_model.dart
│       ├── providers/       # State management
│       │   ├── auth_provider.dart
│       │   ├── loan_provider.dart
│       │   └── language_provider.dart
│       ├── screens/         # UI screens
│       │   ├── splash_screen.dart
│       │   ├── auth/        # Authentication screens
│       │   ├── dashboard/   # Dashboard screens
│       │   ├── loan/        # Loan management screens
│       │   └── profile/     # Profile screens
│       ├── services/        # API and business logic services
│       ├── utils/           # Utilities and helpers
│       │   └── app_localizations.dart
│       └── widgets/         # Reusable UI components
├── test/                    # Unit and widget tests
├── integration_test/        # Integration tests
├── pubspec.yaml            # Project dependencies
├── analysis_options.yaml   # Dart analysis configuration
└── README.md               # Project documentation
```

### Data Models
- **UserModel**: User profile and authentication data
- **BankModel**: Bank information and loan terms
- **CompanyModel**: Contracted company details
- **LoanModel**: Loan request and status tracking
- **CreditLimitModel**: Credit limits per user-bank-company

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / Xcode
- Git

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd flutter_finance_loan_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure API endpoints**
Update the API URLs in the provider files to match your backend endpoints.

4. **Run the application**
```bash
# For development
flutter run

# For production
flutter build apk --release
flutter build ios --release
```

### Dependencies
- **flutter_localizations**: Internationalization support
- **provider**: State management
- **http**: HTTP client for API calls
- **shared_preferences**: Local storage
- **flutter_secure_storage**: Secure storage for tokens
- **cached_network_image**: Image caching
- **flutter_svg**: SVG support

## API Integration

### Authentication Endpoints
- `POST /auth/login` - User login
- `POST /auth/logout` - User logout

### Loan Management Endpoints
- `GET /banks` - Fetch available banks
- `GET /companies` - Fetch contracted companies
- `GET /loans/user/:id` - Fetch user loans
- `GET /credit-limits/user/:id` - Fetch credit limits
- `POST /loans` - Submit new loan request

## Internationalization

The app supports three languages with full RTL support:

1. **English** (LTR)
2. **Arabic** (RTL)
3. **Kurdish** (RTL)

Language switching is available in the profile screen and persists across app sessions.

## Security Features

- **Token-based authentication**
- **Encrypted storage for sensitive data**
- **HTTPS API communication**
- **Input validation and sanitization**
- **Secure session management**

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

### Widget Tests
```bash
flutter test test/widget/
```

## Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
