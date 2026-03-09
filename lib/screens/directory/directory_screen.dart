import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/place_model.dart';
import '../../providers/listings_provider.dart';
import 'place_detail_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});
  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  String _searchQuery = "";
  String _selectedCategory = "Cafés";
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
      setState(() {});
    } catch (e) {
      _currentPosition = Position(
        latitude: -1.9441,
        longitude: 30.1035,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
  }

  double _calculateDistance(double lat, double lng) {
    if (_currentPosition == null) return 0;
    const double earthRadius = 6371;
    double dLat = _toRadians(lat - _currentPosition!.latitude);
    double dLng = _toRadians(lng - _currentPosition!.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(_currentPosition!.latitude)) *
            cos(_toRadians(lat)) *
            sin(dLng / 2) *
            sin(dLng / 2);
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
        title: const Text("Kigali City", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["Cafés", "Pharmacies", "Coffee"].map((cat) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: _selectedCategory == cat,
                    onSelected: (selected) => setState(() => _selectedCategory = cat),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.white,
                    labelStyle: TextStyle(
                      color: _selectedCategory == cat ? Colors.black : Colors.black87,
                      fontWeight: _selectedCategory == cat ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                )).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for a service",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1A2332),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Near You",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Consumer<ListingsProvider>(
              builder: (context, listingsProvider, child) {
                if (listingsProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
                }

                if (listingsProvider.error != null) {
                  return Center(
                    child: Text(
                      'Error: ${listingsProvider.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                
                final filtered = listingsProvider.searchAndFilter(_searchQuery, _selectedCategory);

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
                              children: List.generate(5, (index) => Icon(
                                index < place.rating.floor() ? Icons.star : Icons.star_border,
                                color: Colors.orange,
                                size: 16,
                              )),
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