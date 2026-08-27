# 📚 FlashLearn — Flutter Flashcard Quiz App

<p align="center">
  <b>A modern, interactive, and offline-first flashcard learning application built with Flutter.</b>
</p>

<p align="center">
  <a href="https://github.com/AliZain3311/codealpha-flashcard-quiz">
    <img src="https://img.shields.io/badge/GitHub-Repository-black?style=for-the-badge&logo=github" alt="GitHub">
  </a>
  <img src="https://img.shields.io/badge/Flutter-3.38.9-02569B?style=for-the-badge&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.10.8-0175C2?style=for-the-badge&logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Storage-Hive-orange?style=for-the-badge" alt="Hive">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20Web%20%7C%20Windows-blue?style=for-the-badge" alt="Platform">
</p>

---

## 📖 About The Project

**FlashLearn** is a modern Flutter-based flashcard learning and quiz application designed to make studying more interactive, organized, and engaging.

The application allows users to create and manage flashcards, study them through an interactive learning mode, test their knowledge using quizzes, track learning progress, and review previous quiz attempts.

FlashLearn uses **Hive local storage**, allowing important learning data and quiz history to persist locally on the device without requiring an internet connection.

This project was developed as part of my **CodeAlpha App Development Internship**.

---

## 🎯 Project Objective

The main objective of FlashLearn is to provide a simple but powerful digital learning environment where users can:

- Create personalized flashcards
- Organize flashcards by categories
- Study flashcards interactively
- Test knowledge through quizzes
- Track study progress
- View quiz performance statistics
- Review previous quiz attempts
- Keep learning data stored locally

---

# ✨ Key Features

## 🗂️ Flashcard Management

Users can manage their own flashcard collection.

- ➕ Add new flashcards
- ✏️ Edit existing flashcards
- 🗑️ Delete flashcards
- 📚 View all flashcards
- 🏷️ Organize cards using categories
- 💾 Persist flashcards using local storage

---

## 🧠 Interactive Study Mode

FlashLearn provides a dedicated study experience for reviewing flashcards.

Users can:

- Open their flashcard collection
- Navigate through cards
- Review questions and answers
- Track studied cards
- Monitor learning progress

---

## 📝 Quiz Mode

The application includes an interactive multiple-choice quiz system.

### Quiz functionality includes:

- Multiple-choice questions
- Four answer options
- Correct/incorrect answer feedback
- Question progress indicator
- Score calculation
- Final quiz result
- Quiz completion tracking

A minimum number of flashcards is required before starting a quiz.

---

## 📊 Quiz Statistics

FlashLearn provides a summary of quiz performance directly on the Home screen.

The dashboard displays:

| Statistic | Description |
|-----------|-------------|
| 🏆 Best Score | Highest percentage achieved |
| 📈 Average | Average percentage across completed quizzes |
| 📝 Quizzes | Total number of completed quizzes |

These statistics are generated from the stored quiz history.

---

## 🕘 Quiz History

Every completed quiz can be stored locally and reviewed later.

Quiz history includes information such as:

- Score
- Total questions
- Percentage
- Date and time of the attempt

The complete history can be accessed using the **History icon** in the application header.

---

## 📈 Learning Progress

The Home dashboard provides an overview of the user's learning progress.

It displays:

- Total flashcards
- Studied flashcards
- Overall learning percentage
- Available categories

This makes it easier for users to understand their study progress at a glance.

---

# 💾 Local Data Storage

FlashLearn uses **Hive** for local data persistence.

The application stores important information locally, including:

- Flashcards
- Studied card information
- Quiz history
- Quiz performance data

This provides an **offline-first learning experience** and reduces the need for external backend services for the application's core functionality.

---

# 🎨 User Interface

The application follows a clean and modern UI approach with:

- Material Design components
- Consistent typography
- Rounded cards
- Clear visual hierarchy
- Progress indicators
- Meaningful icons
- Responsive layouts
- Accessible button labels
- Clear success and error feedback

The interface is designed to keep the learning experience simple and distraction-free.

---

# 🛠️ Technology Stack

| Technology | Purpose |
|-----------|---------|
| **Flutter** | Cross-platform application framework |
| **Dart** | Application programming language |
| **Hive** | Local data persistence |
| **Hive Flutter** | Flutter integration for Hive |
| **Material Design** | UI components and visual system |
| **Shared Flutter Services** | Application data and business logic |

---

# 🏗️ Project Architecture

FlashLearn follows a simple and maintainable Flutter project structure.

```text
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