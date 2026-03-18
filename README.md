# BookNest - Smart Library Management App

## Project Overview
BookNest is a mobile library management system built using Flutter and Firebase. The app replaces traditional manual library registers with a modern, digital system that allows users to seamlessly discover books, check availability, borrow or reserve books, track their borrow history, and write reviews and ratings. It also provides essential tools for librarians to maintain the book catalogue and manage borrowing records efficiently.

## Features
- **Book Discovery**: Browse books by genre, search books by title or author, and view detailed information for each book.
- **Borrowing System**: Check book availability in real-time, borrow books, track borrowed items, and process returns.
- **Author Profiles**: View a comprehensive author listing, individual author profiles, and all books written by an author.
- **Reviews & Ratings**: Share your thoughts by rating books and writing detailed reviews.
- **Member Accounts**: Secure sign-up and login, profile management, and personalized borrow history tracking.
- **Library Dashboard**: A centralized view offering a summary of borrowed books, book availability updates, and catalogue management tools for administrators.

## Technologies Used
**Frontend:**
- Flutter
- Dart

**Backend:**
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Functions

**Tools:**
- GitHub (Version Control/Collaboration)
- Postman (API Documentation)

## Folder Structure
```text
lib/
 ┣ main.dart        # Application entry point
 ┣ screens/         # UI screens (e.g., Home, Login, BookDetails)
 ┣ widgets/         # Reusable UI components
 ┣ services/        # Firebase integration and business logic
 ┣ models/          # Data classes (e.g., Book, User)
 ┗ utils/           # Helper functions, themes, and constants

docs/
 ┣ flutter_firebase_postman.json
 ┗ ARCHITECTURE.md
```

## Firebase Setup Instructions
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new project named **BookNest**.
3. Add an Android/iOS app to your project and download the initialization files (`google-services.json` / `GoogleService-Info.plist`).
4. Place the configuration files in the appropriate mobile platform directories (`android/app/` and `ios/Runner/`).
5. In the console, enable **Authentication** (Email/Password), **Cloud Firestore**, and **Firebase Storage**.
6. Set up suitable Security Rules for Firestore and Storage to limit unauthenticated access.
7. Deploy any required background logic using Firebase Cloud Functions.

## Deployment Instructions

### Running Locally
1. Clone the repository and navigate to the project root.
2. Install dependencies by running:
   ```bash
   flutter pub get
   ```
3. Run the application on a connected device or emulator:
   ```bash
   flutter run
   ```

### Building APK
To generate a release APK for Android deployment, execute:
```bash
flutter build apk
```

## Contributing Guidelines
We welcome contributions to BookNest! Follow these steps:
1. **Fork** the repository.
2. **Create a feature branch** (`git checkout -b feature/your-feature-name`).
3. **Commit your changes** with descriptive messages (`git commit -m "Added author filtering feature"`).
4. **Push to the branch** (`git push origin feature/your-feature-name`).
5. **Submit a pull request** explaining your changes.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Reflection Section
- **Why API documentation is important**: Comprehensive API documentation ensures a common understanding of endpoints, expected payloads, and responses. For a decoupled frontend (Flutter) and backend (Firebase), this smooths development and minimizes integration bugs.
- **How versioning helps maintain consistency**: Using version increments (like v1.0.0) ensures backwards compatibility. This prevents newer updates from breaking older versions of the mobile app still in use by some members.
- **How architecture documentation improves collaboration**: Having an `ARCHITECTURE.md` file ensures all team members, regardless of when they join, understand the system boundaries, data flow, and directory layouts, thereby aligning efforts and speeding up the onboarding process.

---

## Responsive Layout Implementation 
**Sprint 2 Task:** Implementing a Responsive Mobile UI 

This task focuses on designing adaptive mobile interfaces in Flutter that automatically adjust to various screen sizes, device types (tablets vs phones), and orientations using `MediaQuery`, `LayoutBuilder`, and flutter’s flexible layout widgets (`Expanded`, `Flexible`, and `AspectRatio`).

### Screenshots
*(Note: Please replace the placeholder links below with actual emulator screenshots before your final submission)*

- ![Mobile Portrait State](docs/screenshots/mobile_portrait.png)
- ![Tablet Landscape State](docs/screenshots/tablet_landscape.png)

### Implementation Code Snippet
Using `MediaQuery` and `LayoutBuilder` to pivot between a single-column and a dual-column layout dynamically:
```dart
double screenWidth = MediaQuery.of(context).size.width;
bool isTablet = screenWidth > 600;

return LayoutBuilder(
  builder: (context, constraints) {
    if (isTablet) {
      // Return Two-column grid layout for tablets 
      return Row(
        children: [ Expanded(child: _buildSidebar()), Expanded(child: _buildMainContent(constraints)) ],
      );
    } else {
      // Return Single-column layout for phones
      return Column(
        children: [ Expanded(child: _buildMainContent(constraints)), _buildFooterArea() ],
      );
    }
  },
);
```

### Reflection
**Challenges Faced:** Managing widgets within nested strict constraints (e.g. `AspectRatio` inside of Grid items inside `Expanded`) often leads to `RenderBox was not laid out` or clipping overflow exceptions during rapid orientation changes. Addressing this involved appropriately utilizing `Flexible` vs `Expanded` boundaries.

**How responsive design improves User Experience:** Serving the same UI across fundamentally different screen sizes leads to poor user scenarios where things look artificially stretched, or there is heavy wasted negative space on large screens (tablets). By intercepting these dimensional state changes instantly, users gain highly natural, accessible, and intuitive experiences unhindered by their hardware platform constraints.

---

## Firebase Integration Implementation
**Sprint 2 Task:** Integrating Firebase Auth and Firestore Database

This task focuses on integrating Firebase to enable real user authentication alongside a NoSQL cloud database (Firestore) to perform structured cloud CRUD operations directly from the mobile application.

### Setup Steps
1. Configured the project via Firebase Console.
2. Installed dependencies dynamically via `flutter pub add firebase_core firebase_auth cloud_firestore`.
3. Overrode `main()` in `lib/main.dart` with `WidgetsFlutterBinding.ensureInitialized();` and `await Firebase.initializeApp();`.

### Implementation Code Snippets
**Authentication Logic (`auth_service.dart`):**
```dart
Future<User?> signUp(String email, String password) async {
  try {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  } catch (e) {
    print(e);
    return null;
  }
}
```

**Firestore Logic (`firestore_service.dart`):**
```dart
Future<void> addUserData(String uid, Map<String, dynamic> data) async {
  await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
}
```

### Screenshots
*(Note: Please replace the placeholder links below with actual screenshots prior to submission)*
- ![Signup / Login Screen](docs/screenshots/app_login_screen.png)
- ![Firestore Logic View](docs/screenshots/app_firestore_logic.png)
- ![Firebase Console Entries](docs/screenshots/firebase_console_entries.png)

### Reflection
**How does Firebase simplify backend management in mobile apps?**
Firebase completely abstracts away the necessity to spin up dedicated virtual servers, load balancers, and bespoke API routes just to handle simple JSON documents or user sessions. By leveraging out-of-the-box native SDKs and Security Rules, we can directly and securely communicate with the database from our Flutter clients in a real-time, reactive fashion without building complex mid-tier boilerplate.

**What did you learn about connecting Flutter with cloud services?**
We learned how streaming inherently aligns with Flutter's reactive widget nature. For example, utilizing `FirebaseAuth.instance.authStateChanges()` paired perfectly with a `StreamBuilder` in `main.dart`, instantly rebuilding the root Application structure and implicitly navigating the user to the Dashboard moments after a successful signup block resolves.\

# 🚀 Flutter Environment Setup and Verification

## 📌 Description

This project demonstrates the successful setup of the Flutter development environment, including installation of the Flutter SDK, configuration of Android Studio/VS Code, and running a Flutter application on an emulator.

This setup serves as the foundation for building mobile applications using Flutter and integrating Firebase in future tasks.

---

## 🛠 Steps Followed

### 1. Installed Flutter SDK
- Downloaded Flutter SDK from official website
- Extracted to local directory
- Added Flutter to system PATH

Verified installation using:

---

### 2. Set Up Development Environment
- Installed Android Studio
- Installed Flutter and Dart plugins
- Installed required SDK components:
  - Android SDK
  - AVD Manager

---

### 3. Configured Emulator
- Opened AVD Manager
- Created virtual device (Pixel series)
- Installed Android system image
- Launched emulator

Verified using:

---

## 📱 Running Flutter Application

### 1. Create Flutter Project
```bash
flutter create book_nest
cd book_nest
```

### 2. Run Application
```bash
flutter run
```

### 3. Verify Output
Application launched successfully on emulator:

---

## 📸 Screenshots

### Flutter Installation Verification
```bash
flutter doctor
```

![Flutter Doctor Output](docs/screenshots/flutter_doctor.png)

### Running Flutter App
```bash
flutter run
```

![Flutter App Running](docs/screenshots/flutter_app_running.png)

### Emulator Verification
![Android Emulator Running](docs/screenshots/emulator_running.png)

---

## 📚 Technologies Used

- **Flutter SDK**: Version 3.x
- **Dart**: Version 3.x
- **Android Studio**: Version 2023.x
- **Android Emulator**: Pixel 5 (API 33)

---

## 🎯 Key Learnings

1. **Flutter Installation**: Proper SDK installation and PATH configuration are critical for development
2. **Environment Setup**: Android Studio plugins and SDK components must be properly configured
3. **Emulator Management**: AVD Manager allows creating and managing virtual devices for testing
4. **Project Creation**: `flutter create` command initializes new Flutter projects
5. **Running Apps**: `flutter run` command compiles and launches applications on connected devices/emulators

---

## 📝 Notes

- Ensure sufficient system resources (RAM, disk space) for emulator operation
- Keep Flutter SDK and Android Studio updated for latest features and bug fixes
- Use `flutter doctor` regularly to verify environment health
- Test on multiple emulator configurations for broader compatibility

---

## 🔗 Resources

- [Flutter Official Website](https://flutter.dev/)
- [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)
- [Android Studio Setup](https://docs.flutter.dev/get-started/install/android)
- [Flutter Emulator Setup](https://docs.flutter.dev/get-started/install/android#run-on-a-simulator-or-emulator)

---

**Project Root**: `/Users/tanviagarwal/S63-0326-ATA-FlutterFirebase-BookNest`
**Flutter Version**: 3.38.3
**Dart Version**: 3.10.1
**Android Studio Version**: 2023.3.1
**Emulator**: Pixel 5 (API 33)

---

*This setup is complete and ready for Firebase integration in the next sprint.*


---

## 📁 Flutter Project Structure Exploration

This task explores the complete Flutter project structure and explains the purpose of each folder and configuration file.

📄 Detailed documentation:
👉 See [PROJECT_STRUCTURE.md](./PROJECT_STRUCTURE.md)

---

## 📸 Folder Structure Screenshot

(Add screenshot of your project structure here)

---

## 🤔 Reflection

Understanding Flutter project structure is important because:

- It helps organize code efficiently
- Improves development speed
- Makes collaboration easier in team projects

A well-structured project allows team members to:
- Work on different modules independently
- Avoid confusion
- Maintain clean and scalable code