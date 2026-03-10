import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../services/firestore_service.dart';
import '../../models/place_model.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  // Default camera position focused on Kigali
  static const _kigaliCenter = CameraPosition(
    target: LatLng(-1.9441, 30.1035),
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Text("Kigali Services Map", style: TextStyle(color: Colors.white)),
      ),
      body: kIsWeb
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, size: 100, color: Colors.orange),
                  const SizedBox(height: 16),
                  const Text(
                    'Map View',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Google Maps is not available on web.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please run the app on Android or iOS to view the map.',
                    style: TextStyle(color: Colors.white54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : StreamBuilder<List<Place>>(
              stream: FirestoreService().getPlaces(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
                }

                Set<Marker> markers = snapshot.data!.map((place) {
                  return Marker(
                    markerId: MarkerId(place.id),
                    position: LatLng(place.lat, place.lng),
                    infoWindow: InfoWindow(
                      title: place.name,
                      snippet: place.category,
                    ),
                  );
                }).toSet();

                return GoogleMap(
                  initialCameraPosition: _kigaliCenter,
                  markers: markers,
                  myLocationEnabled: true,
                );
              },
            ),
    );
  }
}