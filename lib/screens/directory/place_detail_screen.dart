import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../models/place_model.dart';
import '../../models/review_model.dart';
import '../../services/firestore_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/bookmark_provider.dart';
import 'reviews_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  Future<void> _launchNavigation() async {
    final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${place.lat},${place.lng}";
    
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).user?.uid;
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final isBookmarked = userId != null && bookmarkProvider.isBookmarked(place.id);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: Text(place.name, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              color: const Color(0xFF1A2332),
              child: place.imageUrl != null
                  ? Image.network(place.imageUrl!, fit: BoxFit.cover)
                  : const Center(
                      child: Icon(Icons.image, size: 80, color: Colors.white30),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.coffee, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${place.category} • 0.6 km",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    place.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _showRatingDialog(context),
                      child: const Text(
                        "Rate this service",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D1B2A),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1 && userId != null) {
            bookmarkProvider.toggleBookmark(userId, place.id);
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReviewsScreen(place: place)),
            );
          }
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: "Bookmarks"),
          BottomNavigationBarItem(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            label: "Bookmarks",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    double rating = 0;
    final commentController = TextEditingController();
    final userId = Provider.of<AuthProvider>(context, listen: false).user?.uid;
    final userName = Provider.of<AuthProvider>(context, listen: false).user?.displayName ?? 'Anonymous';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2332),
        title: const Text('Rate this service', style: TextStyle(color: Colors.white)),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                  ),
                  onPressed: () => setState(() => rating = index + 1.0),
                )),
              ),
              TextField(
                controller: commentController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Write your review...',
                  hintStyle: TextStyle(color: Colors.white54),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              if (rating > 0 && userId != null) {
                final review = Review(
                  id: '',
                  placeId: place.id,
                  userId: userId,
                  userName: userName,
                  rating: rating,
                  comment: commentController.text,
                  timestamp: DateTime.now(),
                );
                await FirestoreService().addReview(review);
                Navigator.pop(context);
              }
            },
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}