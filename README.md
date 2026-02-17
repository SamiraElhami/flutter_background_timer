This README is designed to be professional, clear, and focused on the technical implementation of background timing, which is the core value of your repository.

---

# Flutter Background Timer

A robust Flutter timer implementation using **BLoC/Cubit** that accurately tracks time even when the app is in the background, terminated, or the device is restarted.

## 🚀 The Problem

Standard `Timer.periodic` in Flutter stops or becomes unreliable when the app moves to the background or is killed by the OS. This project solves that by calculating "elapsed background time" using local storage and timestamps.

## ✨ Features

* ⏱️ **Persistent Countdown**: Timer continues logic even if the app is killed.
* 📱 **Background Aware**: Automatically calculates time difference when the app resumes.
* 🏗️ **Clean Architecture**: Built using `flutter_bloc` for state management.
* 💾 **Local Persistence**: Uses a `StorageManager` to keep track of timer states.
* 🧪 **Unit Tested**: Includes comprehensive tests using `bloc_test` and `mocktail`.

## 🛠️ Installation

Add the dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.0
  shared_preferences: ^2.2.0
  clock: ^1.1.1

```

## 🧠 How it Works

The magic happens in the `currentTimer()` logic within the `TimerCubit`:

1. **Going Background**: When the app is paused, we save the `current_seconds` and a `timestamp` (Epoch).
2. **Resuming**: When the app returns, we calculate:
   `Actual Remaining = Saved Seconds - (Current Time - Saved Timestamp)`
3. **Sync**: The UI immediately emits the corrected state.

## 💻 Usage

### Initializing the Cubit

```dart
final timerCubit = TimerCubit(
  storageManager: TimerStorageManager(),
);

// Load previous state (if any)
timerCubit.init();

```

### Basic Actions

```dart
// Start a timer for 60 seconds
context.read<TimerCubit>().start(60);

// Pause timer (saves state to storage)
context.read<TimerCubit>().pause();

// Resume timer
context.read<TimerCubit>().resume();

```

### Handling App Lifecycle

To ensure the timer saves its state when the user swipes the app away, use the `onBackground` hook:

```dart
// Inside your State or App Lifecycle Listener
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.paused) {
    timerCubit.onBackground();
  }
}

```

## 🧪 Testing

This project is fully tested without relying on the real system clock. To run the tests:

```bash
flutter test

```

## 🤝 Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE]() file for details.

---

**Maintained by [Samira Elhami**]()