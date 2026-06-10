# Psychological Assessment

A modern, offline-first psychological assessment platform built with Flutter. Provides validated screening tools and psychological tests for mental health professionals and researchers.

## Features

- **18 validated assessments** covering mood, anxiety, personality, sleep, behavior, and more
- **Offline-first** — all data stays on-device, no internet required after initial load
- **Bangla (Bengali) language** — full localization with `Noto Serif Bengali` for all body text
- **PDF export** — generate and share professional assessment reports
- **Detailed scoring** — automatic scoring with severity bands, interpretations, and suggestions
- **Responsive UI** — optimized for mobile, tablet, and desktop (LG 4:3 / MD 3:2 ratios)
- **Dark mode** — full dark theme support
- **Riverpod state management** — reactive, testable architecture

## Included Assessments

| Test | Category | Items |
|------|----------|-------|
| SRQ-20 — Self-Reporting Questionnaire | Screening | 20 |
| C-SSRS — Columbia-Suicide Severity Rating Scale | Screening | 7 |
| WHO-5 — Well-Being Index | Screening | 5 |
| DASS-21 — Depression, Anxiety, Stress Scale | Mood | 21 |
| PHQ-9 — Patient Health Questionnaire | Mood | 9 |
| GAD-7 — Generalized Anxiety Disorder | Mood | 7 |
| PSS — Perceived Stress Scale | Mood | 10 |
| RSES — Rosenberg Self-Esteem Scale | Self | 10 |
| BHS — Beck Hopelessness Scale | Self | 20 |
| LSAS — Liebowitz Social Anxiety Scale | Self | 28 |
| SWLS — Satisfaction with Life Scale | Self | 5 |
| ISI — Insomnia Severity Index | Sleep | 7 |
| OCI-R — Obsessive-Compulsive Inventory | Behavior | 20 |
| IAT — Internet Addiction Test | Behavior | 18 |
| FTND — Fagerstrom Nicotine Dependence Scale | Behavior | 6 |
| OLS — Obsessive Love Scale | Behavior | 13 |
| TIPI — Ten-Item Personality Inventory | Personality | 10 |
| DTDD — Dark Triad Dirty Dozen | Personality | 12 |

## Tech Stack

- **Framework:** Flutter 3.44+ / Dart 3.12+
- **State management:** Riverpod + Riverpod Generator
- **Routing:** GoRouter
- **PDF generation:** `pdf` + `printing` packages
- **Icons:** Lucide Icons
- **Fonts:** Google Fonts (Outfit, Noto Serif Bengali, Tiro Bangla)
- **Responsive:** Custom breakpoints (SM <640 / MD 640-1024 / LG ≥1024)

## Project Structure

```
lib/
├── core/
│   └── design_system/
│       ├── app_theme.dart       # Colors, spacing, radius
│       └── responsive.dart      # Breakpoints, grid, max-width
├── features/
│   ├── about/
│   │   └── presentation/
│   │       └── about_screen.dart
│   ├── assessment/
│   │   ├── data/
│   │   │   ├── assessment_repository.dart
│   │   │   └── test_data_providers.dart
│   │   ├── domain/
│   │   │   ├── assessment_models.dart
│   │   │   ├── assessment_bundle.dart
│   │   │   └── scoring_engine.dart
│   │   └── presentation/
│   │       ├── widgets/         # Reusable UI components
│   │       ├── test_list_screen.dart
│   │       ├── test_detail_screen.dart
│   │       ├── assessment_runner_screen.dart
│   │       ├── assessment_results_screen.dart
│   │       └── scoring_procedure_dialog.dart
│   └── upcoming/
│       └── presentation/
│           └── upcoming_screen.dart
└── main.dart
```

## Getting Started

### Prerequisites

- Flutter SDK ^3.12.0
- Dart SDK ^3.12.0

### Installation

```bash
git clone <repository-url>
cd psychological_assessment
flutter pub get
flutter run
```

### Build for Web

```bash
flutter build web
```

### Build for Android

```bash
flutter build apk
```

## Upcoming Tests

- Pittsburgh Sleep Quality Index (PSQI)
- DU Anxiety Scale (Dhaka University)
- DU Depression Scale (Dhaka University)
- GHQ 28 Questionnaire
- Hospital Anxiety & Depression Scale (HADS)
- Social Interaction Anxiety Scale (SIAS)
- Somatic Complaints Scale
- Cognitive Distortion Scale
- Cognitive Emotion Regulation Questionnaire (CERQ, Revised 2016)

## Developer

**Md Asifuzzaman Reyad**

- Facebook: [/asifuzzamanreyad](https://www.facebook.com/asifuzzamanreyad)
- LinkedIn: [/in/asifuzzamanreyad](https://linkedin.com/in/asifuzzamanreyad)
- WhatsApp: [+880 1704-340860](https://wa.me/+8801704340860)
- YouTube: [@sofolitltd](https://youtube.com/@sofolitltd)

## Disclaimer

This application is intended for educational and research purposes. It does not replace professional psychological evaluation or diagnosis. Results should be interpreted by qualified mental health professionals.

## License

MIT

---

Built with Flutter.
# psychological-assessment
