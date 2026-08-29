# 📚 FlashLearn

<p align="center">
  <img src="assets/flashlearn_icon.png" width="120" alt="FlashLearn Logo">
</p>

<h1 align="center">FlashLearn</h1>

<p align="center">
  <strong>Learn • Practice • Improve</strong>
</p>

<p align="center">
  A modern, interactive, and offline-first flashcard and quiz learning application built with Flutter.
</p>

<p align="center">
  <a href="https://github.com/AliZain3311/codealpha-flashcard-quiz">
    <img src="https://img.shields.io/badge/GitHub-Repository-181717?style=for-the-badge&logo=github" alt="GitHub Repository">
  </a>
  <img src="https://img.shields.io/badge/Flutter-3.38.9-02569B?style=for-the-badge&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.10.8-0175C2?style=for-the-badge&logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Hive-Local%20Storage-FF8A00?style=for-the-badge" alt="Hive">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20Web%20%7C%20Windows-4F46E5?style=for-the-badge" alt="Platform">
</p>

---

## 📖 About FlashLearn

**FlashLearn** is a modern Flutter-based flashcard and quiz learning application designed to make studying more interactive, organized, and engaging.

The application provides a complete learning workflow where users can:

- 📚 Create and manage flashcards
- 🗂️ Organize flashcards by category
- 🧠 Study flashcards interactively
- 📝 Take multiple-choice quizzes
- 📈 Track learning progress
- 📊 View quiz performance statistics
- 🕘 Review previous quiz attempts
- 💾 Store learning data locally

FlashLearn follows an **offline-first approach** using **Hive local storage**, allowing important learning information to remain available on the device without requiring an internet connection.

This project was developed as part of my **CodeAlpha App Development Internship**.

---

## 🎯 Project Objective

The main objective of FlashLearn is to provide a simple but powerful digital learning environment that helps users:

- 📚 Create personalized flashcards
- 🗂️ Organize cards using categories
- 🧠 Study flashcards interactively
- 📝 Test knowledge through quizzes
- 📈 Track study progress
- 📊 Monitor quiz performance
- 🕘 Review previous quiz attempts
- 💾 Keep learning data stored locally
- 📱 Continue learning offline

---

# ✨ Key Features

## 🗂️ Flashcard Management

FlashLearn provides complete flashcard management functionality.

- ➕ Add new flashcards
- ✏️ Edit existing flashcards
- 🗑️ Delete flashcards
- 📚 View all flashcards
- 🏷️ Organize cards by category
- 💾 Store flashcards locally
- 🔄 Automatically update learning data

---

## 🧠 Interactive Study Mode

The dedicated Study Mode provides an easy way to review learning material.

Users can:

- Open available flashcards
- Navigate through flashcards
- Review questions and answers
- Track studied cards
- Monitor study progress
- Continue learning without an internet connection

---

## 📝 Interactive Quiz Mode

FlashLearn includes an interactive multiple-choice quiz system designed to test the user's knowledge.

### Quiz Features

- ❓ Multiple-choice questions
- 🔘 Four answer options
- ✅ Correct answer feedback
- ❌ Incorrect answer feedback
- 📍 Question progress indicator
- 🧮 Automatic score calculation
- 🏆 Final quiz result
- 💾 Quiz completion history
- 🔄 Continue learning after quizzes

The application validates the available flashcards before allowing a quiz to begin.

---

# 📊 Quiz Statistics

The Home dashboard includes a dedicated **Quiz Statistics** section.

The statistics are generated from the stored quiz history.

| Statistic | Description |
|-----------|-------------|
| 🏆 **Best Score** | Highest percentage achieved |
| 📈 **Average** | Average percentage across completed quizzes |
| 📝 **Total Quizzes** | Total number of completed quizzes |

These statistics are connected to the locally stored quiz history and update as quiz attempts are completed.

---

# 🕘 Quiz History

FlashLearn stores completed quiz attempts locally.

Each history record can contain:

- 🎯 Score
- 📝 Total questions
- 📊 Percentage
- 📅 Date
- ⏰ Time of the attempt

Users can access their complete quiz history through the application's History interface.

---

# 📈 Learning Progress

The Home dashboard provides a quick overview of the user's learning progress.

It displays:

- 📚 Total flashcards
- ✅ Studied flashcards
- 📈 Overall learning percentage
- 🗂️ Available categories

This allows users to understand their learning progress at a glance.

---

# 💾 Offline-First Storage

FlashLearn uses **Hive** for local data persistence.

### Locally stored information includes:

- Flashcards
- Studied flashcard IDs
- Quiz history
- Quiz scores
- Quiz percentages
- Learning progress

This architecture allows the application's core learning functionality to work without requiring a remote backend.

---

# 🎨 Modern UI / UX

FlashLearn was designed with a clean, modern, and user-friendly visual experience.

### UI Highlights

- 🎨 Modern color scheme
- 🧩 Rounded cards
- ✨ Clean visual hierarchy
- 📊 Progress indicators
- 🔘 Modern buttons
- 🎯 Meaningful icons
- 📱 Mobile-friendly layouts
- ♿ Clear and accessible controls
- 🔔 Success and error feedback
- 🧭 Simple navigation
- 💎 Consistent application theme

The design focuses on keeping the learning experience **simple, focused, and distraction-free**.

---

# 🖼️ Application Branding

FlashLearn includes custom application branding.

### 📱 Custom App Icon

The application uses a dedicated FlashLearn app icon.

### 🚀 Custom Splash Screen

A branded FlashLearn splash screen is displayed when the application starts before opening the main dashboard.

Branding assets are maintained inside:

```text
assets/
├── flashlearn_icon.png
└── flashlearn_splash.png
📱 Application Screenshots
🚀 Splash Screen
<p align="center"> <img src="screenshots/01_splash.png" width="260" alt="FlashLearn Splash Screen"> </p>
🏠 Home Dashboard
<p align="center"> <img src="screenshots/02_home.png" width="260" alt="FlashLearn Home Dashboard"> </p>
📚 Flashcards
<p align="center"> <img src="screenshots/03_flashcards.png" width="260" alt="FlashLearn Flashcards"> </p>
🧠 Study Mode
<p align="center"> <img src="screenshots/04_study.png" width="260" alt="FlashLearn Study Mode"> </p>
📝 Quiz Mode
<p align="center"> <img src="screenshots/05_quiz.png" width="260" alt="FlashLearn Quiz"> </p>
🏆 Quiz Result
<p align="center"> <img src="screenshots/06_quiz_result.png" width="260" alt="FlashLearn Quiz Result"> </p>
🕘 Quiz History
<p align="center"> <img src="screenshots/07_quiz_history.png" width="260" alt="FlashLearn Quiz History"> </p>
🛠️ Technology Stack
Technology	Purpose
Flutter 3.38.9	Cross-platform application framework
Dart 3.10.8	Programming language
Hive 2.2.3	Local data persistence
Hive Flutter	Flutter integration for Hive
Path Provider	Local application storage support
Material Design	UI components and design system
Git & GitHub	Version control and source management
🏗️ Project Architecture

FlashLearn follows a clean and maintainable Flutter structure.

lib/
│
├── app/
│   └── app.dart
│
├── data/
│   └── sample_flashcards.dart
│
├── models/
│   └── flashcard_model.dart
│
├── screens/
│   ├── add_edit_flashcard_screen.dart
│   ├── flashcards_screen.dart
│   ├── home_screen.dart
│   ├── quiz_history_screen.dart
│   ├── quiz_result_screen.dart
│   ├── quiz_screen.dart
│   ├── splash_screen.dart
│   └── study_screen.dart
│
├── services/
│   ├── progress_service.dart
│   ├── quiz_history_service.dart
│   └── storage_service.dart
│
├── theme/
│   └── app_theme.dart
│
└── main.dart
📂 Project Structure
codealpha-flashcard-quiz/
│
├── assets/
│   ├── flashlearn_icon.png
│   └── flashlearn_splash.png
│
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
│
├── lib/
│   ├── app/
│   ├── data/
│   ├── models/
│   ├── screens/
│   ├── services/
│   ├── theme/
│   └── main.dart
│
├── screenshots/
│   ├── 01_splash.png
│   ├── 02_home.png
│   ├── 03_flashcards.png
│   ├── 04_study.png
│   ├── 05_quiz.png
│   ├── 06_quiz_result.png
│   └── 07_quiz_history.png
│
├── test/
│   └── widget_test.dart
│
├── pubspec.yaml
├── pubspec.lock
└── README.md
⚙️ Installation
Prerequisites

Install the following:

Flutter SDK
Dart SDK
Android Studio
Android SDK
VS Code or another Flutter-compatible IDE
1. Clone the Repository
git clone https://github.com/AliZain3311/codealpha-flashcard-quiz.git

Then:

cd codealpha-flashcard-quiz
2. Install Dependencies
flutter pub get
3. Check Flutter Environment
flutter doctor
4. Run the Application
Android
flutter run
Chrome
flutter run -d chrome
Windows
flutter run -d windows
🧪 Testing

The project includes Flutter widget testing and static analysis.

Run static analysis:

flutter analyze

Run automated tests:

flutter test

The final project has been verified using Flutter analysis and automated tests.

📦 Release APK

To create a production Android APK:

flutter build apk --release

Generated APK location:

build/app/outputs/flutter-apk/app-release.apk

The release APK can be installed directly on a compatible Android device.

🚀 Web Build

To create a production web build:

flutter build web --release

Generated web files:

build/web/
🔄 Development Workflow

A typical FlashLearn learning workflow is:

Create / Manage Flashcards
          ↓
      Study Cards
          ↓
      Take Quiz
          ↓
   Calculate Score
          ↓
 Save Quiz History
          ↓
Update Statistics
          ↓
 Track Learning Progress
🎓 CodeAlpha Internship

FlashLearn was developed as part of the:

CodeAlpha App Development Internship

The project demonstrates practical experience in:

📱 Flutter application development
💻 Dart programming
🎨 Mobile UI/UX design
💾 Local database management
🏗️ Application architecture
🔄 Data persistence
📝 Quiz logic
📈 Progress tracking
🧪 Flutter testing
🐙 Git & GitHub
👨‍💻 Developer
<p align="center">
Ali Zain

<strong>Bachelor of Science in Information Technology (BSIT)</strong>

<br>

<strong>Flutter & Mobile Application Developer</strong>

</p>
🔗 Developer Profiles
🐙 GitHub: AliZain3311
💼 LinkedIn: Ali Zain
💻 Skills Demonstrated
Flutter
Dart
Mobile Application Development
Hive
Local Data Persistence
UI/UX Design
Application Architecture
Git & GitHub
Flutter Testing
🔮 Future Improvements

Potential future improvements include:

☁️ Cloud synchronization
👤 User authentication
📊 Advanced learning analytics
🔔 Study reminders
🌙 Dark mode
🔊 Text-to-speech
🤖 AI-generated flashcards
🧠 AI-powered adaptive quizzes
📚 Larger subject-specific question banks
🏆 Gamification and achievement system
🔄 Cross-device synchronization
📄 License

This project was developed for educational and internship purposes.