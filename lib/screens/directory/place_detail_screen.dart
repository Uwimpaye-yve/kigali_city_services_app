import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this to your pubspec.yaml
import '../../models/place_model.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  // Method to launch turn-by-turn directions
  Future<void> _launchNavigation() async {
    final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${place.lat},${place.lng}";
    
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Embedded Google Map
            SizedBox(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(place.lat, place.lng),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(place.id),
                    position: LatLng(place.lat, place.lng),
                    infoWindow: InfoWindow(title: place.name),
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(place.category, style: const TextStyle(color: Colors.orange)),
                  const SizedBox(height: 10),
                  Text(place.description),
                  const SizedBox(height: 20),
                  
                  // THE NAVIGATION BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      icon: const Icon(Icons.navigation, color: Colors.white),
                      label: const Text("Launch Turn-by-Turn Directions", style: TextStyle(color: Colors.white)),
                      onPressed: _launchNavigation,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}