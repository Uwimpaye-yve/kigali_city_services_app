# Kigali City Services App

A Flutter application for discovering and reviewing city services in Kigali, Rwanda.

## Features

- **Service Directory**: Browse cafés, pharmacies, and other services with ratings and distance
- **Reviews & Ratings**: Rate and review services with a 5-star system
- **Bookmarks**: Save your favorite places for quick access
- **User Authentication**: Secure login with Firebase Authentication
- **Real-time Updates**: Live data synchronization with Cloud Firestore
- **Dark Theme**: Modern dark UI matching the design specifications

## Setup Instructions

### Prerequisites
- Flutter SDK (>=3.10.0)
- Firebase account
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   cd kigali_city_services_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at https://console.firebase.google.com
   - Enable Authentication (Email/Password)
   - Enable Cloud Firestore
   - Run FlutterFire CLI to generate firebase_options.dart:
     ```bash
     flutterfire configure
     ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── models/
│   ├── place_model.dart       # Place/Service data model
│   └── review_model.dart      # Review data model
├── providers/
│   ├── auth_provider.dart     # Authentication state management
│   └── bookmark_provider.dart # Bookmarks state management
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart  # Login/Signup screen
│   │   └── wrapper.dart       # Auth state wrapper
│   ├── directory/
│   │   ├── directory_screen.dart      # Main services list
│   │   ├── category_list_screen.dart  # Category-filtered list
│   │   ├── place_detail_screen.dart   # Service details
│   │   ├── reviews_screen.dart        # Reviews list
│   │   └── bookmarks_screen.dart      # Saved places
│   ├── home/
│   │   └── home_screen.dart   # Main navigation
│   └── settings/
│       └── settings_screen.dart # User settings
├── services/
│   └── firestore_service.dart # Firestore database operations
└── main.dart                   # App entry point
```

## Firestore Database Structure

### Collections

**listings**
```json
{
  "name": "Kimironko Café",
  "category": "Café",
  "address": "Kimironko, Kigali",
  "contact": "+250 XXX XXX XXX",
  "description": "Popular neighborhood café...",
  "lat": -1.9441,
  "lng": 30.1035,
  "userId": "user_id",
  "rating": 4.8,
  "reviewCount": 45,
  "imageUrl": "https://...",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

**reviews**
```json
{
  "placeId": "listing_id",
  "userId": "user_id",
  "userName": "Eric",
  "rating": 5.0,
  "comment": "Great coffee and friendly staff!",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

**users/{userId}/bookmarks**
```json
{
  "timestamp": "2024-01-01T00:00:00Z"
}
```

## Key Dependencies

- `firebase_core`: Firebase initialization
- `firebase_auth`: User authentication
- `cloud_firestore`: Real-time database
- `provider`: State management
- `google_maps_flutter`: Map integration
- `geolocator`: Location services
- `url_launcher`: External navigation

## UI Design

The app implements a dark theme with:
- Primary color: Dark Navy (#0D1B2A)
- Accent color: Orange
- Card background: #1A2332
- Text: White/White70

## Notes

- Replace placeholder values in `firebase_options.dart` with your actual Firebase configuration
- For location features, ensure location permissions are granted
- The app uses IndexedStack to preserve state across navigation

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
