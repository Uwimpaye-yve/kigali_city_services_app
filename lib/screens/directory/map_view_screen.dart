import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      appBar: AppBar(title: const Text("Kigali Services Map")),
      body: StreamBuilder<List<Place>>(
        stream: FirestoreService().getPlaces(), // Listen to real-time updates
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          // Convert Place objects from Firestore into Map Markers
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