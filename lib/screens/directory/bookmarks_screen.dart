import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/place_model.dart';
import '../../services/firestore_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/bookmark_provider.dart';
import 'place_detail_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  bool _bookmarksEnabled = true;

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).user?.uid;
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Text("Bookmarks", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2332),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Bookmarks",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: _bookmarksEnabled,
                    onChanged: (value) => setState(() => _bookmarksEnabled = value),
                    activeColor: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: userId == null
                ? const Center(
                    child: Text(
                      "Please log in to see bookmarks",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : StreamBuilder<List<String>>(
                    stream: bookmarkProvider.getBookmarkedPlaceIds(userId),
                    builder: (context, bookmarkSnapshot) {
                      if (!bookmarkSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator(color: Colors.orange));
                      }

                      final bookmarkedIds = bookmarkSnapshot.data!;

                      if (bookmarkedIds.isEmpty) {
                        return const Center(
                          child: Text(
                            "No bookmarks yet",
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      return StreamBuilder<List<Place>>(
                        stream: FirestoreService().getPlaces(),
                        builder: (context, placesSnapshot) {
                          if (!placesSnapshot.hasData) {
                            return const Center(child: CircularProgressIndicator(color: Colors.orange));
                          }

                          final bookmarkedPlaces = placesSnapshot.data!
                              .where((place) => bookmarkedIds.contains(place.id))
                              .toList();

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: bookmarkedPlaces.length,
                            itemBuilder: (context, index) {
                              final place = bookmarkedPlaces[index];
                              return Card(
                                color: const Color(0xFF1A2332),
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  title: Text(
                                    place.name,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Row(
                                            children: List.generate(
                                              5,
                                              (i) => Icon(
                                                i < place.rating.floor() ? Icons.star : Icons.star_border,
                                                color: Colors.orange,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            place.rating.toStringAsFixed(1),
                                            style: const TextStyle(color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.bookmark, color: Colors.orange),
                                    onPressed: () => bookmarkProvider.toggleBookmark(userId, place.id),
                                  ),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlaceDetailScreen(place: place),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D1B2A),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
