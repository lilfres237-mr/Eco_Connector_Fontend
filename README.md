# TPCs Mobile App — Flutter (Android)

The mobile app for **Trash Pickup Connector (TPCs)** — built with Flutter, targeting Android. It contains two distinct role-based experiences from a single codebase: **Household** and **Rider**.

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Platform](https://img.shields.io/badge/platform-Android-brightgreen)
![Status](https://img.shields.io/badge/status-in%20development-yellow)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Environment Setup (Supabase Keys)](#environment-setup-supabase-keys)
- [Running the App](#running-the-app)
- [User Roles](#user-roles)
- [Key Packages](#key-packages)
- [Related Repos / Docs](#related-repos--docs)

---

## Overview

This app connects households requesting trash pickup with independent riders who collect and deposit it at recycling centers. Users register as **either** a Household **or** a Rider — never both — and see a completely different home screen and navigation depending on their role.

Core features:
- Single-tap pickup requests with automatic GPS capture
- Real-time pickup status tracking (Pending → Accepted → Rider En Route → Collected → Deposited → Completed)
- Push notifications for both households and riders
- Points wallet with mobile money cash-out
- English/French localization
- Offline-friendly for low-bandwidth (2G/3G) conditions

---

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- [Android Studio](https://developer.android.com/studio) with the Flutter and Dart plugins installed
- An Android emulator (set up via Android Studio's Device Manager) or a physical Android device with USB debugging enabled
- Access to the project's Supabase instance (ask a team lead for keys, or see [Environment Setup](#environment-setup-supabase-keys) if setting up your own)

Run this to confirm your environment is ready:
```bash
flutter doctor
```
Fix anything marked with a ✗ before continuing.

---

## Getting Started

```bash
# from inside the mobile/ folder
flutter pub get
flutter run
```

Make sure an emulator is running (▶️ in Android Studio's Device Manager) or a physical device is plugged in and detected — check with:
```bash
flutter devices
```

---

## Project Structure

```
mobile/
├── lib/
│   ├── main.dart              # app entry point
│   ├── core/                  # theme, constants, shared widgets
│   ├── auth/                  # register, login, OTP verification screens
│   ├── household/             # household-facing screens
│   │   ├── home_screen.dart
│   │   ├── request_pickup_screen.dart
│   │   ├── track_rider_screen.dart
│   │   └── history_screen.dart
│   ├── rider/                 # rider-facing screens
│   │   ├── home_screen.dart
│   │   ├── job_detail_screen.dart
│   │   └── earnings_screen.dart
│   ├── models/                # data models (mirrors database/schema.sql)
│   ├── services/              # Supabase client, API calls, location services
│   └── widgets/                # shared reusable UI components
├── android/                   # native Android project files
├── assets/                    # images, icons, fonts
├── pubspec.yaml                # dependencies
└── README.md                  # this file
```

---

## Environment Setup (Supabase Keys)

This app connects to Supabase for auth, database, and realtime features. Create a file at `lib/core/env.dart` (already gitignored) with:

```dart
class Env {
  static const supabaseUrl = 'YOUR_SUPABASE_PROJECT_URL';
  static const supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

> ⚠️ Never commit real keys. `env.dart` should be listed in `.gitignore`. Ask a team lead for the shared development project's keys, or create your own free Supabase project and run `database/schema.sql` from the main repo against it.

---

## Running the App

| Task | Command |
|---|---|
| Install dependencies | `flutter pub get` |
| Run on connected device/emulator | `flutter run` |
| Run in release mode | `flutter run --release` |
| Check for issues | `flutter analyze` |
| Run tests | `flutter test` |
| Build an APK | `flutter build apk` |

---

## User Roles

| Role | What they see |
|---|---|
| **Household** | Request/schedule pickups, track collection, points wallet, history |
| **Rider** | Accept nearby jobs, update pickup status, navigate to household/center, earnings |

Role is selected once at registration (`I am a: Household / Rider`) and determines which set of screens the app routes to after login.

---

## Key Packages

_(update this list as you add dependencies to `pubspec.yaml`)_

| Package | Purpose |
|---|---|
| `supabase_flutter` | Auth, database, realtime |
| `google_maps_flutter` | Maps, location display |
| `geolocator` | Device GPS access |
| `firebase_messaging` | Push notifications |
| `flutter_localizations` + `intl` | English/French support |
| `sqflite` or `hive` | Offline local storage queue |

---

## Related Repos / Docs

- Backend (Next.js API): see `../backend/README.md`
- Database schema: see `../database/schema.sql`
- Full requirements (SRS/TRS): see `../docs/SRS_TRS.docx`
- Development roadmap: see `../docs/roadmap.md`