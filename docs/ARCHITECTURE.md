# BookNest Architecture Guide

## System Overview
BookNest operates on a scalable, serverless full-stack architecture. The robust mobile frontend is developed using **Flutter** and **Dart**, offering a smooth cross-platform experience. It communicates directly with a **Firebase** backend. Firebase provides all necessary functionality including real-time databases, authentication, file storage, and serverless compute capabilities to handle business logic efficiently.

## Tech Stack
- **Flutter**: Cross-platform declarative UI framework for Android and iOS.
- **Firebase Authentication**: Handles fast and secure user sign-up, login, and session token management.
- **Cloud Firestore**: A flexible, scalable NoSQL cloud database used to store and sync the application's data.
- **Firebase Storage**: Object storage utilized for media items like user profile pictures and book cover imagery.
- **Cloud Functions**: Serverless functions that trigger on Firebase events (or HTTP requests) to securely execute background backend logic.

## Directory Structure
```text
lib/
 ┣ main.dart        # Application entry point configuring themes and routes
 ┣ screens/         # Flutter screens representing independent UI pages
 ┣ widgets/         # Shareable, reusable widgets (cards, list tiles, buttons)
 ┣ services/        # APIs, network calls, and Firebase interactions
 ┣ models/          # Dart strongly-typed entity models
 ┗ utils/           # Shared utilities, extensions, and constants

docs/
 ┣ flutter_firebase_postman.json  # Exported API and Integration definitions
 ┗ ARCHITECTURE.md                # High-level system design and schemas
```

## Data Flow
The data flow relies heavily on Firebase's direct-client access model, monitored by rigorous server-side security rules.

```text
[ User / Flutter App ] 
         |
         | (Authenticates & Gets Token)
         v
[ Firebase Auth ]
         |
         | (Reads/Writes structured data using Auth context)
         +---------------------------------> [ Cloud Firestore ]
         |                                           |
         | (Uploads/Downloads media)                 | (Triggers background tasks)
         v                                           v
[ Firebase Storage ]                        [ Cloud Functions ]
```

1. **User → Flutter App**: The user interacts with the UI (e.g. searching for a book or submitting a review).
2. **Flutter App → Firebase Auth**: The app authenticates the user directly, obtaining a secure JWT.
3. **Flutter App → Firestore**: Using the active session, the app reads or writes directly to the Firestore Database (enforced by Security Rules).
4. **Flutter App → Storage**: Assets like book covers are retrieved natively from Firebase Storage.
5. **Cloud Functions**: Advanced background operations (e.g. recalculating average book ratings or processing overdue accounts) trigger server-side automatically based on state changes.

## Firestore Database Schema
The Firestore database structures data into logical, independent NoSQL collections. 

### 1. `users` Collection
Stores both regular members and librarian profiles.
```json
{
  "uid": "user_id_string",
  "displayName": "John Doe",
  "email": "johndoe@example.com",
  "role": "member", // or "librarian"
  "createdAt": "Timestamp"
}
```

### 2. `books` Collection
Holds details regarding the entire library catalogue.
```json
{
  "bookId": "book_id_string",
  "title": "The Great Gatsby",
  "author": "F. Scott Fitzgerald",
  "genre": "Classic",
  "isbn": "978-0743273565",
  "availableCopies": 3,
  "totalCopies": 5,
  "coverImageUrl": "https://storage.googleapis.com/.../cover.jpg",
  "averageRating": 4.5
}
```

### 3. `borrowRecords` Collection
Tracks the lifecycle of book rentals to inform availability.
```json
{
  "recordId": "record_id_string",
  "userId": "user_id_string",
  "bookId": "book_id_string",
  "borrowDate": "Timestamp",
  "dueDate": "Timestamp",
  "returnDate": null, // Stays null until the user physically returns the item
  "status": "active" // Can be "active", "returned", or "overdue"
}
```

### 4. `reviews` Collection
Stores the subjective ratings and reviews authored by library members.
```json
{
  "reviewId": "review_id_string",
  "bookId": "book_id_string",
  "userId": "user_id_string",
  "rating": 5,
  "reviewText": "An absolute masterpiece. Read it in one sitting.",
  "createdAt": "Timestamp"
}
```
