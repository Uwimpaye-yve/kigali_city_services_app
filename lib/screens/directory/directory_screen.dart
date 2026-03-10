import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/place_model.dart';
import '../../providers/listings_provider.dart';
import '../../providers/auth_provider.dart';
import 'place_detail_screen.dart';
import 'add_listing_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});
  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  String _searchQuery = "";
  String _selectedCategory = "All";
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

  void _addSampleData(BuildContext context) async {
    final provider = Provider.of<ListingsProvider>(context, listen: false);
    final userId = Provider.of<AuthProvider>(context, listen: false).user?.uid ?? 'test';

    final samples = [
      Place(id: '', name: 'Kimironko Café', category: 'Café', address: 'Kimironko, Kigali', contact: '+250 788 123 456', description: 'Popular café with fresh coffee', lat: -1.9441, lng: 30.1035, userId: userId, rating: 4.8, reviewCount: 45),
      Place(id: '', name: 'Green Bean Coffee', category: 'Café', address: 'City Tower', contact: '+250 788 234 567', description: 'Premium coffee shop', lat: -1.9506, lng: 30.0588, userId: userId, rating: 4.0, reviewCount: 32),
      Place(id: '', name: 'City Pharmacy', category: 'Pharmacy', address: 'Downtown', contact: '+250 788 345 678', description: '24/7 pharmacy', lat: -1.9536, lng: 30.0606, userId: userId, rating: 4.5, reviewCount: 28),
    ];

    for (var place in samples) await provider.addPlace(place);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sample data added!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Text("Kigali City", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", "Cafés", "Pharmacies", "Hospitals", "Parks"].map((cat) => Padding(
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
                
                final allPlaces = listingsProvider.places;
                final filtered = listingsProvider.searchAndFilter(_searchQuery, _selectedCategory);

                if (allPlaces.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inbox, color: Colors.white30, size: 80),
                        const SizedBox(height: 16),
                        const Text('No listings yet', style: TextStyle(color: Colors.white, fontSize: 18)),
                        const SizedBox(height: 8),
                        const Text('Add sample data to get started', style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          onPressed: () => _addSampleData(context),
                          child: const Text('Add Sample Data', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, color: Colors.white30, size: 80),
                        const SizedBox(height: 16),
                        Text('No results', style: const TextStyle(color: Colors.white, fontSize: 18)),
                        const SizedBox(height: 8),
                        Text('Total: ${allPlaces.length} | Category: $_selectedCategory', style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          onPressed: () => setState(() { _searchQuery = ''; _selectedCategory = 'All'; }),
                          child: const Text('Clear Filters', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                }

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddListingScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}