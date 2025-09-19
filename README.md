# Mat

Flutter Android experience that allows SACCO members to review their KYC
profile, registered vehicles, and loan facilities in a clean, data-rich
GetX-powered dashboard.

## Features

- **Insightful overview:** Gradient header summarises membership health with
  total arrears, outstanding balances, fleet count, and last sync timestamp.
- **Account snapshot:** Contact details, gender, branch, and join date laid out
  in responsive cards for quick KYC verification.
- **Fleet carousel:** Horizontally scrollable vehicle cards highlight route,
  onboarding date, and vehicle type distribution chips.
- **Loan intelligence:** Progress indicators, repayment summaries, and
  arrears alerts for each facility with aggregate loan metrics.
- **Offline-friendly UX:** GetX controller caches demo data, shows retryable
  error banners, and supports pull-to-refresh for a realistic SACCO sync flow.

## Getting started

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) 3.16.0 or newer
  (Dart 3.2.0+)
- Android toolchain (Android Studio or `sdkmanager`) for building/running on
  an emulator or device

### Install dependencies

```bash
flutter pub get
```

### Run the Android app

```bash
flutter run -d android
```

### Run quality checks

```bash
flutter analyze
flutter test
```

## Project structure

```
lib/
├── app/
│   ├── app.dart                 # Root GetMaterialApp configuration
│   ├── bindings/                # Global dependency bindings
│   ├── modules/
│   │   └── dashboard/           # Member dashboard feature module
│   │       ├── dashboard_page.dart
│   │       └── widgets/         # Reusable dashboard widgets
│   ├── theme/                   # Shared theming
│   └── utils/                   # Formatting helpers
├── controllers/                 # GetX controllers
├── data/                        # Data sources (demo repository)
├── models/                      # Domain models (member, vehicle, loan)
└── main.dart                    # App entry point
```
