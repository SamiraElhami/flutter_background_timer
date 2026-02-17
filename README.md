

# Flutter Background Timer

A Flutter timer implementation using **BLoC/Cubit** that accurately tracks time even when the app is in the background, terminated, or the device is restarted.

## 🚀 Key Components

* **`BackgroundTimer`**: The core widget that manages the lifecycle and display of your timer.
* **`TimerController`**: A handle that allows you to pause, resume, or reset the timer from anywhere in your UI.

---
## 🚀 The Problem

Standard `Timer.periodic` in Flutter stops or becomes unreliable when the app moves to the background or is killed by the OS. This project solves that by calculating "elapsed background time" using local storage and timestamps.

---
## ✨ Features

* ⏱️ **Persistent Countdown**: Timer continues logic even if the app is killed.
* 📱 **Background Aware**: Automatically calculates time difference when the app resumes.
* 🏗️ **Clean Architecture**: Built using `flutter_bloc` for state management.
* 💾 **Local Persistence**: Uses a `StorageManager` to keep track of timer states.
* 🧪 **Unit Tested**: Includes comprehensive tests using `bloc_test` and `mocktail`.
---

## 🛠️ Installation

Add the dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  background_timer_package: ^1.0.0
```
---
## 🧠 How it Works

The magic happens in the `currentTimer()` logic within the `TimerCubit`:

1. **Going Background**: When the app is paused, we save the `current_seconds` and a `timestamp` (Epoch).
2. **Resuming**: When the app returns, we calculate:
   `Actual Remaining = Saved Seconds - (Current Time - Saved Timestamp)`
3. **Sync**: The UI immediately emits the corrected state.
---
## 💻 Usage

### 1. Initializing the Controller

```dart
final myController = TimerController();

BackgroundTimer(seconds: 60, controller: myController,
storageManager: TimerStorageManager(),);

```

### 2. Using the BackgroundTimer

To control the timer from a button elsewhere in your app, initialize a `TimerController`.

```dart
class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  // 1. Create the controller
  final TimerController _controller = TimerController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 2. Pass it to the widget
        BackgroundTimer(
          controller: _controller,
          seconds: 120,
        ),
        
        // 3. Use it to trigger actions
        Row(
          children: [
            ElevatedButton(
              onPressed: () => _controller.pause(),
              child: Text("Pause"),
            ),
            ElevatedButton(
              onPressed: () => _controller.resume(),
              child: Text("Resume"),
            ),
            ElevatedButton(
              onPressed: () => _controller.reset(60),
              child: Text("Reset to 1 min"),
            ),
          ],
        ),
      ],
    );
  }
}

```

---

## 🛠️ Advanced: Custom Storage

By default, this package uses `shared_preferences`. If you want to use a different database (like Hive or Secure Storage), simply implement the `TimerStorage` interface:

```dart
class MyHiveStorage implements TimerStorage {
  @override
  Future<void> saveSeconds(int seconds) async { /* Your Hive logic */ }

  @override
  Future<int?> loadSeconds() async { /* Your Hive logic */ }

  @override
  Future<void> clear() async { /* Your Hive logic */ }
}

// Then pass your custom manager to the timer
final myManager = TimerStorageManager(customStorage: MyHiveStorage());

```

---

## 📋 API Reference

### TimerController

| Method | Description |
| --- | --- |
| `pause()` | Pauses the timer and saves the current state to storage. |
| `resume()` | Resumes the timer, accounting for any time passed in the background. |
| `reset(int seconds)` | Stops the current timer and starts a new one with the given duration. |
| `remainingSeconds` | A getter that returns the current integer value of the countdown. |

### BackgroundTimer

| Property         | Type                   | Description                                             |
|------------------|------------------------|---------------------------------------------------------|
| `seconds`        | `int`                  | The initial duration of the countdown.                  |
| `controller`     | `TimerController?`     | Optional controller for external manipulation.          |
| `storageManager` | `TimerStorageManager?` | Optional storage for storing the timer values.  (if nothing provided it will use the SHaredPreferences)        |


---


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