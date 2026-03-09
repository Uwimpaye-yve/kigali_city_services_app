# Quick Setup Guide

## 1. Firebase Configuration

### Step 1: Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### Step 2: Configure Firebase
```bash
flutterfire configure
```
This will:
- Create/select a Firebase project
- Generate `firebase_options.dart` with your actual credentials
- Configure all platforms (Android, iOS, Web)

### Step 3: Enable Firebase Services
1. Go to https://console.firebase.google.com
2. Select your project
3. Enable **Authentication** → Email/Password
4. Enable **Cloud Firestore** → Create database in test mode

### Step 4: Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /listings/{listing} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /reviews/{review} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /users/{userId}/bookmarks/{bookmark} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 2. Location Permissions

### Android (android/app/src/main/AndroidManifest.xml)
Add before `<application>`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS (ios/Runner/Info.plist)
Add before `</dict>`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location to show nearby services.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location to show nearby services.</string>
```

## 3. Google Maps API (Optional)

### Android
1. Get API key from Google Cloud Console
2. Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<application>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_API_KEY_HERE"/>
</application>
```

### iOS
1. Add to `ios/Runner/AppDelegate.swift`:
```swift
import GoogleMaps

GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

## 4. Run the App

```bash
# Get dependencies
flutter pub get

# Run on connected device
flutter run

# Or run on specific device
flutter run -d chrome  # Web
flutter run -d android # Android
flutter run -d ios     # iOS
```

## 5. Test Data (Optional)

Add sample data to Firestore manually:

### Collection: listings
```json
{
  "name": "Kimironko Café",
  "category": "Café",
  "address": "Kimironko, Kigali",
  "contact": "+250 788 123 456",
  "description": "Popular neighborhood café offering fresh coffee pastries, and light meals in a cozy setting.",
  "lat": -1.9441,
  "lng": 30.1035,
  "userId": "test_user",
  "rating": 4.8,
  "reviewCount": 45,
  "imageUrl": null
}
```

```json
{
  "name": "Green Bean Coffee",
  "category": "Coffee",
  "address": "Kigali City Tower",
  "contact": "+250 788 234 567",
  "description": "Premium coffee shop with excellent service.",
  "lat": -1.9506,
  "lng": 30.0588,
  "userId": "test_user",
  "rating": 4.0,
  "reviewCount": 32,
  "imageUrl": null
}
```

## 6. Common Issues

### Issue: Firebase not initialized
**Solution**: Make sure you ran `flutterfire configure`

### Issue: Location not working
**Solution**: Check permissions in AndroidManifest.xml and Info.plist

### Issue: Maps not showing
**Solution**: Add Google Maps API key

### Issue: Build errors
**Solution**: Run `flutter clean && flutter pub get`

## 7. Verify Setup

1. ✅ App launches without errors
2. ✅ Can create account and login
3. ✅ Can see services list
4. ✅ Can view service details
5. ✅ Can add reviews
6. ✅ Can bookmark services
7. ✅ Distance shows correctly
8. ✅ Can logout

## Need Help?

- Flutter Docs: https://docs.flutter.dev
- Firebase Docs: https://firebase.google.com/docs
- FlutterFire: https://firebase.flutter.dev
