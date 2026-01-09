# GradePlanner

A cross-platform mobile application for tracking academic grades and calculating what you need on remaining assessments to achieve your target grade.

## Features

- **Grade Tracking**: Track grades across multiple semesters and courses
- **Assessment Management**: Add, edit, and delete individual assessments with weights
- **Grade Calculation**: Automatic grade-to-date and weighted average calculations
- **What-If Analysis**: Calculate what grade you need on remaining assessments to hit your target
- **Visual Progress**: View grade progression through interactive charts
- **Data Persistence**: Saves data locally in JSON format

## Tech Stack

- Flutter / Dart
- Provider (State Management)
- FL Chart (Data Visualization)
- SQLite / JSON (Data Persistence)

## Screenshots

The app includes:
- Main dashboard showing all semesters
- Course detail view with assessment list
- Grade progression chart
- What-if calculator

## Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK
- Android Studio / Xcode (for mobile deployment)

### Installation

```bash
cd grade_tracker_app
flutter pub get
flutter run
```

### Build for Release

```bash
# Android
flutter build apk

# iOS
flutter build ios
```

## Project Structure

```
grade_tracker_app/
├── lib/
│   ├── main.dart
│   ├── models/           # Data models (Course, Semester, Assessment)
│   ├── providers/        # State management
│   ├── screens/          # UI screens
│   └── widgets/          # Reusable UI components
├── assets/
│   └── data.json         # Sample data
└── pubspec.yaml
```

## What I Learned

- Cross-platform mobile development with Flutter
- State management patterns (Provider)
- Mobile UI/UX design principles
- Data persistence strategies
- Chart/graph visualization in mobile apps
