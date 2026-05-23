# Uellow Vendor App

Flutter mobile app for Uellow marketplace vendors.

## Features
- Login with Uellow vendor credentials
- Dashboard with KPIs (wallet, orders, rating, followers)
- Orders management with filter by status
- FBU Stock status per product variant
- Wallet with transactions + payout request
- Settings: Dark mode toggle, Language (AR/EN)
- Full RTL support for Arabic

## Tech Stack
- Flutter 3.x + Dart 3 (null safety)
- Riverpod 2.x (state management)
- GoRouter (navigation)
- Dio (HTTP client)
- flutter_secure_storage (JWT token)
- SharedPreferences (theme + language)

## API Backend
All calls go to: `https://uellow.com/api/vendor/*`

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/vendor/login` | Authenticate + get JWT token |
| GET | `/api/vendor/dashboard` | Store stats |
| GET | `/api/vendor/orders?state=all` | Orders list |
| GET | `/api/vendor/stock` | FBU stock per variant |
| GET | `/api/vendor/wallet` | Balance + transactions |

## Setup

```bash
# Install Flutter 3.x
# https://docs.flutter.dev/get-started/install

cd uellow_vendor_app
flutter pub get
flutter run
```

## Build

```bash
# Android
flutter build apk --release

# iOS
flutter build ipa --release
```

## Project Structure

```
lib/
  core/
    api/          # Dio client + ApiResult
    constants/    # URLs, keys
    theme/        # Colors + ThemeData (light/dark)
    utils/        # GoRouter
    l10n/         # Localization
  features/
    auth/         # Login screen + provider
    dashboard/    # Home screen + provider
    orders/       # Orders screen + provider
    stock/        # FBU stock screen + provider
    wallet/       # Wallet screen + provider
    settings/     # Settings screen (theme/lang)
  shared/
    models/       # VendorModel, OrderModel, etc.
    widgets/      # StatCard, StatusBadge, LoadingShimmer
assets/
  translations/   # en.json, ar.json
```
