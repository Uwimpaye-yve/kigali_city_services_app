import 'package:flutter/material.dart';
import '../../models/place_model.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.name)),
      body: Center(child: Text("Details for ${place.name}")),
    );
  }
}