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
We learned how streaming inherently aligns with Flutter's reactive widget nature. For example, utilizing `FirebaseAuth.instance.authStateChanges()` paired perfectly with a `StreamBuilder` in `main.dart`, instantly rebuilding the root Application structure and implicitly navigating the user to the Dashboard moments after a successful signup block resolves.
