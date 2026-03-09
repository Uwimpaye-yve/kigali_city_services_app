# UI Implementation Guide

This document maps the UI design screens to the implemented Flutter screens.

## Screen 1: Kigali City (Home/Directory)

**File**: `lib/screens/directory/directory_screen.dart`

### Design Elements Implemented:
- ✅ Dark navy background (#0D1B2A)
- ✅ "Kigali City" title in app bar
- ✅ Back arrow button
- ✅ Category chips (Cafés, Pharmacies, Coffee) - white background
- ✅ Search bar with "Search for a service" placeholder
- ✅ "Near You" section header
- ✅ Service cards with:
  - Service name (bold white text)
  - Star rating (orange stars)
  - Rating number (e.g., 4.3)
  - Distance (e.g., 0.6 km)
- ✅ Card background (#1A2332)
- ✅ Bottom navigation (Home, Bookmarks, Reviews, Settings)

### Key Features:
- Real-time distance calculation from user location
- Category filtering
- Search functionality
- Tap to view details

---

## Screen 2: Cafés (Category List)

**File**: `lib/screens/directory/category_list_screen.dart`

### Design Elements Implemented:
- ✅ Dark navy background
- ✅ Category name as title (e.g., "Cafés")
- ✅ "Services" section header
- ✅ List of services with same card design as Screen 1
- ✅ Rating display with stars
- ✅ Distance calculation
- ✅ Bottom navigation

### Navigation:
- Accessible by tapping category chips on home screen
- Can be extended to show "Pharmacies 5" badge

---

## Screen 3: Kimironko Café (Service Detail)

**File**: `lib/screens/directory/place_detail_screen.dart`

### Design Elements Implemented:
- ✅ Dark navy background
- ✅ Service name as title
- ✅ Image placeholder (gray box with image icon)
- ✅ Service name (large bold text)
- ✅ Category icon + text (e.g., "☕ Café • 0.6 km")
- ✅ Description text
- ✅ Orange "Rate this service" button
- ✅ Bottom navigation with bookmark functionality

### Features:
- Image display (if imageUrl provided)
- Rating dialog with 5-star selection
- Comment input
- Bookmark toggle
- Navigation to reviews

---

## Screen 4: Reviews

**File**: `lib/screens/directory/reviews_screen.dart`

### Design Elements Implemented:
- ✅ Dark navy background
- ✅ "Reviews" title
- ✅ "AV. B rating" label
- ✅ Star rating display (5 orange stars)
- ✅ Review count (e.g., "45 reviews")
- ✅ Individual review cards with:
  - Reviewer name (e.g., "Eric", "Sarah")
  - Review text in quotes
  - Timestamp (e.g., "m ago")
- ✅ "Arviews" section at bottom
- ✅ Rating summary (4.8 ⭐ 45 reviews)
- ✅ Bottom navigation

### Features:
- Real-time review updates
- Timestamp formatting (minutes/hours/days ago)
- Scrollable review list

---

## Screen 5: Bookmarks

**File**: `lib/screens/directory/bookmarks_screen.dart`

### Design Elements Implemented:
- ✅ Dark navy background
- ✅ "Bookmarks" title
- ✅ Toggle switch card at top
  - "Bookmarks" label
  - Orange toggle switch
  - White card background
- ✅ List of bookmarked services
- ✅ Same card design as other screens
- ✅ Bottom navigation (Services, Bookings, Settings)

### Features:
- Real-time bookmark sync
- Toggle to enable/disable bookmarks
- Remove bookmark by tapping bookmark icon
- Empty state message

---

## Common UI Elements

### Color Palette
```dart
Background:      Color(0xFF0D1B2A)  // Dark Navy
Card:            Color(0xFF1A2332)  // Lighter Navy
Accent:          Colors.orange      // Orange
Text Primary:    Colors.white       // White
Text Secondary:  Colors.white70     // White 70%
Text Tertiary:   Colors.white54     // White 54%
```

### Typography
```dart
Title:           fontSize: 24, fontWeight: FontWeight.bold
Subtitle:        fontSize: 18, fontWeight: FontWeight.bold
Body:            fontSize: 14, color: Colors.white70
Caption:         fontSize: 12, color: Colors.white54
```

### Bottom Navigation
```dart
backgroundColor:     Color(0xFF0D1B2A)
selectedItemColor:   Colors.orange
unselectedItemColor: Colors.white60
type:                BottomNavigationBarType.fixed
```

### Cards
```dart
color:         Color(0xFF1A2332)
borderRadius:  BorderRadius.circular(8)
margin:        EdgeInsets.only(bottom: 12)
padding:       EdgeInsets.all(12)
```

### Buttons
```dart
Primary Button:
  backgroundColor: Colors.orange
  textColor:       Colors.white
  height:          50
  borderRadius:    8
```

### Star Rating Display
```dart
Icon(
  index < rating.floor() ? Icons.star : Icons.star_border,
  color: Colors.orange,
  size: 16,
)
```

---

## Navigation Flow

```
LoginScreen
    ↓
HomeScreen (Bottom Nav)
    ├── DirectoryScreen (Tab 0)
    │   ├── CategoryListScreen
    │   └── PlaceDetailScreen
    │       └── ReviewsScreen
    ├── BookmarksScreen (Tab 1)
    │   └── PlaceDetailScreen
    ├── MapViewScreen (Tab 2)
    └── SettingsScreen (Tab 3)
```

---

## Responsive Design

All screens use:
- `SingleChildScrollView` for vertical scrolling
- `ListView.builder` for efficient list rendering
- `StreamBuilder` for real-time data updates
- `Padding` and `Margin` for consistent spacing
- `SafeArea` implicit in Scaffold

---

## Animations & Interactions

### Implemented:
- ✅ Tap feedback on cards
- ✅ Bottom navigation transitions
- ✅ Dialog animations (rating dialog)
- ✅ Switch toggle animation
- ✅ Loading indicators (CircularProgressIndicator)

### Future Enhancements:
- Hero animations for images
- Slide transitions between screens
- Pull-to-refresh
- Shimmer loading effects

---

## Accessibility

- All interactive elements have proper tap targets (min 48x48)
- Color contrast meets WCAG standards
- Text is readable at default sizes
- Icons have semantic labels

---

## Performance Optimizations

- `IndexedStack` preserves state across tabs
- `StreamBuilder` for efficient real-time updates
- `ListView.builder` for lazy loading
- Minimal rebuilds with proper state management

---

## Testing Checklist

### Visual Testing
- [ ] All screens match design colors
- [ ] Typography is consistent
- [ ] Spacing matches design
- [ ] Icons are correct size and color
- [ ] Cards have proper shadows/elevation

### Functional Testing
- [ ] Navigation works correctly
- [ ] Data loads and displays
- [ ] Interactions provide feedback
- [ ] Empty states show properly
- [ ] Error states handled gracefully

### Cross-Platform Testing
- [ ] Android appearance
- [ ] iOS appearance
- [ ] Web appearance (if applicable)
- [ ] Different screen sizes
- [ ] Dark mode consistency

---

## Notes

1. **Image Placeholders**: Currently showing gray boxes with image icons. Replace with actual images when available.

2. **Distance Calculation**: Uses Haversine formula with user's current location. Falls back to Kigali center if location unavailable.

3. **Rating System**: Automatically calculates average rating when reviews are added. Updates in real-time.

4. **Bookmarks**: Stored per-user in Firestore. Syncs across devices.

5. **Bottom Navigation**: Consistent across all screens with proper highlighting of current tab.

## Conclusion

The implementation closely matches the provided UI design with:
- Exact color scheme
- Proper typography
- Consistent spacing
- All interactive elements
- Real-time data integration
- Smooth navigation flow

All screens are production-ready pending Firebase configuration and testing.
