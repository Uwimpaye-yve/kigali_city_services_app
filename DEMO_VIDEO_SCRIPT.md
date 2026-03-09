# Demo Video Script
## Kigali City Services App - Individual Assignment 2

**Target Duration:** 10-12 minutes  
**Required:** Show Firebase Console concurrently with app

---

## Setup Before Recording

### Screen Layout:
- **Left Side:** Android Emulator/Device running app
- **Right Side:** Firebase Console (Authentication & Firestore tabs)
- **Bottom:** Code editor (VS Code) for showing implementation

### Preparation:
1. Clear Firebase Authentication users
2. Clear Firestore collections
3. Have code editor open with key files
4. Test run everything once

---

## Video Script

### SEGMENT 1: Introduction & Architecture (1 minute)

**[00:00-00:30] Opening**

"Hello, I'm [Your Name], and this is my Kigali City Services App for Individual Assignment 2. This Flutter application helps Kigali residents locate essential services like hospitals, cafés, and police stations using Firebase Authentication and Cloud Firestore."

**[00:30-01:00] Architecture Overview**

*Show folder structure in VS Code*

"The app follows clean architecture with three layers:
- **Service Layer**: FirestoreService handles all Firebase operations
- **Provider Layer**: State management using Provider pattern
- **UI Layer**: Screens that consume providers

Let me show you the key files..."

*Briefly show:*
- `lib/services/firestore_service.dart`
- `lib/providers/listings_provider.dart`
- `lib/screens/directory/directory_screen.dart`

---

### SEGMENT 2: Authentication Flow (2 minutes)

**[01:00-01:30] Signup with Email Verification**

*Show Firebase Console - Authentication tab (empty)*

"First, let's demonstrate the authentication flow. I'll create a new account."

*In app:*
1. Open app (shows login screen)
2. Tap "Sign Up"
3. Enter email: `demo@kigali.rw`
4. Enter password: `Test123!`
5. Tap "SIGN UP"

*Show VerifyEmailScreen appears*

"Notice the app blocks access until email is verified. This is enforced in the AuthWrapper."

**[01:30-02:00] Show Implementation Code**

*Show `lib/screens/auth/wrapper.dart`*

```dart
if (!authProvider.user!.emailVerified) {
  return const VerifyEmailScreen();
}
```

*Show `lib/providers/auth_provider.dart`*

```dart
await result.user?.sendEmailVerification();
```

**[02:00-02:30] Email Verification**

*Switch to email inbox (or simulate)*

"After verifying the email..."

*In app:*
1. Tap "I have verified it"
2. App navigates to HomeScreen

*Show Firebase Console - Authentication*

"You can see the user is now authenticated in Firebase Console with their UID."

**[02:30-03:00] Login & Logout**

*Demonstrate logout and login again*

"The authentication state is managed by AuthProvider, which listens to Firebase auth changes and updates the UI automatically."

---

### SEGMENT 3: CRUD Operations (3 minutes)

**[03:00-03:30] Create a Listing**

*Show Firebase Console - Firestore (empty collections)*

"Now let's create a service listing. I'll add a café."

*In app:*
1. Navigate to "My Listings" tab
2. Tap "Add Listing" (if button exists, or navigate to add screen)
3. Fill in form:
   - Name: "Kimironko Café"
   - Category: "Café"
   - Address: "Kimironko, Kigali"
   - Contact: "+250 788 123 456"
   - Description: "Popular neighborhood café"
4. Tap "Save Listing"

*Show Firebase Console - Firestore*

"Watch the Firebase Console - the listing appears immediately in the 'listings' collection with all fields including the user's UID."

**[03:30-04:00] Show Implementation Code**

*Show `lib/providers/listings_provider.dart`*

```dart
Future<void> addPlace(Place place) async {
  await _firestoreService.addPlace(place);
  notifyListeners();
}
```

*Show `lib/services/firestore_service.dart`*

```dart
Future<void> addPlace(Place place) {
  return _db.collection('listings').add(place.toMap());
}
```

**[04:00-04:30] Read - Directory Screen**

*Navigate to Directory tab*

"The listing automatically appears in the Directory screen. This is powered by StreamBuilder listening to Firestore changes."

*Show implementation code*

```dart
Consumer<ListingsProvider>(
  builder: (context, listingsProvider, child) {
    final places = listingsProvider.places;
    return ListView.builder(...);
  },
)
```

**[04:30-05:00] Update a Listing**

*In app:*
1. Go to "My Listings"
2. Tap edit icon on "Kimironko Café"
3. Change description to "Best coffee in Kigali"
4. Save

*Show Firebase Console*

"The update reflects immediately in Firestore and the UI rebuilds automatically."

**[05:00-05:30] Delete a Listing**

*In app:*
1. Tap delete icon on listing
2. Confirm deletion

*Show Firebase Console*

"The document is removed from Firestore, and the UI updates instantly through the Provider."

*Show delete implementation*

```dart
Future<void> deletePlace(String id) async {
  await _firestoreService.deletePlace(id);
}
```

**[05:30-06:00] Create Multiple Listings**

*Quickly add 2-3 more listings to have data for next segments*

---

### SEGMENT 4: Search & Filter (1.5 minutes)

**[06:00-06:30] Search by Name**

*In Directory screen:*
1. Type "Kimironko" in search bar
2. Show filtered results
3. Clear search
4. Type "Coffee"
5. Show different results

"Search is case-insensitive and updates dynamically as you type."

**[06:30-07:00] Category Filtering**

*In app:*
1. Tap "Cafés" chip
2. Show only cafés
3. Tap "Pharmacies" chip
4. Show only pharmacies

*Show implementation code*

```dart
List<Place> searchAndFilter(String query, String category) {
  return _places.where((place) {
    bool matchesSearch = place.name.toLowerCase().contains(query);
    bool matchesCategory = category == "Cafés" || ...;
    return matchesSearch && matchesCategory;
  }).toList();
}
```

---

### SEGMENT 5: Detail Page & Map Integration (2 minutes)

**[07:00-07:30] Detail Page**

*In app:*
1. Tap on a listing from Directory
2. Show detail page with:
   - Service name
   - Category and distance
   - Description
   - "Rate this service" button

**[07:30-08:00] Embedded Map**

"The detail page includes an embedded Google Map showing the exact location using coordinates stored in Firestore."

*Show map with marker*

*Show implementation code*

```dart
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(place.lat, place.lng),
    zoom: 15,
  ),
  markers: {
    Marker(
      markerId: MarkerId(place.id),
      position: LatLng(place.lat, place.lng),
    ),
  },
)
```

**[08:00-08:30] Launch Navigation**

*In app:*
1. Tap "Rate this service" or navigation button
2. Google Maps opens with directions

"This uses the url_launcher package to open Google Maps with the coordinates."

*Show code*

```dart
final url = "https://www.google.com/maps/search/?api=1&query=${place.lat},${place.lng}";
await launchUrl(Uri.parse(url));
```

---

### SEGMENT 6: Additional Features (1.5 minutes)

**[08:30-09:00] Reviews & Ratings**

*In app:*
1. Open a listing detail
2. Tap "Rate this service"
3. Select 5 stars
4. Write comment: "Excellent service!"
5. Submit

*Show Firebase Console - reviews collection*

"The review is stored in Firestore, and the average rating is automatically calculated and updated on the listing."

**[09:00-09:30] Bookmarks**

*In app:*
1. Tap bookmark icon on a listing
2. Navigate to Bookmarks tab
3. Show bookmarked listing
4. Toggle bookmark off

*Show Firebase Console - users/{uid}/bookmarks*

"Bookmarks are stored per-user in a subcollection, syncing across devices in real-time."

---

### SEGMENT 7: State Management Deep Dive (1.5 minutes)

**[09:30-10:00] Data Flow Explanation**

*Show architecture diagram or code*

"Let me explain how state management works in this app:

1. User action triggers a Provider method
2. Provider calls FirestoreService
3. FirestoreService interacts with Firebase
4. Stream updates trigger notifyListeners()
5. Consumer widgets rebuild automatically"

**[10:00-10:30] Loading & Error States**

*Show code in ListingsProvider*

```dart
bool _isLoading = false;
String? _error;

Future<void> addPlace(Place place) async {
  _isLoading = true;
  notifyListeners();
  
  try {
    await _firestoreService.addPlace(place);
  } catch (e) {
    _error = e.toString();
  }
  
  _isLoading = false;
  notifyListeners();
}
```

"Loading and error states are handled in the Provider and displayed in the UI."

---

### SEGMENT 8: Firestore Schema & Conclusion (1 minute)

**[10:30-11:00] Firestore Collections**

*Show Firebase Console - Firestore*

"The database has three main collections:

1. **listings**: All service listings with name, category, coordinates, rating, etc.
2. **reviews**: User reviews linked to listings by placeId
3. **users/{uid}/bookmarks**: Per-user bookmarked places"

**[11:00-11:30] Closing**

"This app demonstrates:
- Clean architecture with Provider state management
- Full Firebase integration with Authentication and Firestore
- Real-time CRUD operations
- Search and filtering
- Map integration with navigation
- Reviews and bookmarks system

All code is available in my GitHub repository. Thank you for watching!"

---

## Post-Recording Checklist

- [ ] Video is 7-15 minutes
- [ ] Firebase Console shown throughout
- [ ] All CRUD operations demonstrated
- [ ] Implementation code displayed for key features
- [ ] Authentication flow explained
- [ ] State management explained
- [ ] Search/filter demonstrated
- [ ] Map integration shown
- [ ] Audio is clear
- [ ] Screen is readable

---

## Upload Instructions

1. **Export video** in 1080p
2. **Upload to YouTube** (unlisted or public)
3. **Add to Google Drive** (backup)
4. **Include link** in PDF submission

---

## Tips for Recording

- **Speak clearly** and at moderate pace
- **Pause briefly** when switching between app and code
- **Zoom in** on code when showing implementation
- **Highlight** important lines of code
- **Keep Firebase Console visible** when demonstrating CRUD
- **Test everything** before recording
- **Have a script** but sound natural
- **Re-record segments** if needed (edit later)

---

Good luck with your demo video! 🎥
