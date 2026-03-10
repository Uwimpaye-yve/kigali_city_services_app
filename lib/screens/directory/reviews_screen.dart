import 'package:flutter/material.dart';
import '../../models/place_model.dart';
import '../../models/review_model.dart';
import '../../services/firestore_service.dart';

class ReviewsScreen extends StatelessWidget {
  final Place place;
  const ReviewsScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Text("Reviews", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "AV. B rating",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Row(
                      children: List.generate(5, (index) => Icon(
                        index < place.rating.floor() ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                        size: 20,
                      )),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${place.reviewCount} reviews",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Review>>(
              stream: FirestoreService().getReviews(place.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
                }

                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No reviews yet",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final review = snapshot.data![index];
                    return Card(
                      color: const Color(0xFF1A2332),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              review.comment,
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatTimestamp(review.timestamp),
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Arviews",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      place.rating.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      "${place.reviewCount} reviews",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D1B2A),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Bookmarks"),
          BottomNavigationBarItem(icon: Icon(Icons.rate_review), label: "Reviews"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }
}
