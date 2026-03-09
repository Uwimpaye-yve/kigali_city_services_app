import 'package:flutter/material.dart';
import '../../models/place_model.dart';
import '../../services/firestore_service.dart';
import 'place_detail_screen.dart';
import 'dart:math';

class CategoryListScreen extends StatelessWidget {
  final String category;
  const CategoryListScreen({super.key, required this.category});

  double _calculateDistance(double lat, double lng) {
    const double kigaliLat = -1.9441;
    const double kigaliLng = 30.1035;
    const double earthRadius = 6371;
    double dLat = _toRadians(lat - kigaliLat);
    double dLng = _toRadians(lng - kigaliLng);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(kigaliLat)) * cos(_toRadians(lat)) * sin(dLng / 2) * sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * pi / 180;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: Text(category, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Services",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Place>>(
              stream: FirestoreService().getPlaces(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
                }

                final filtered = snapshot.data!
                    .where((p) => p.category.toLowerCase().contains(category.toLowerCase()))
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final place = filtered[i];
                    final distance = _calculateDistance(place.lat, place.lng);
                    return Card(
                      color: const Color(0xFF1A2332),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                place.name,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  place.rating.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                const Icon(Icons.star, color: Colors.orange, size: 16),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  index < place.rating.floor() ? Icons.star : Icons.star_border,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${distance.toStringAsFixed(1)} km",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlaceDetailScreen(place: place)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
