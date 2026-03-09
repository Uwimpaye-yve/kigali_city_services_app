import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  final String id;
  final String name;
  final String category;
  final String address;
  final String contact;
  final String description;
  final double lat;
  final double lng;
  final String userId;
  final double rating;
  final int reviewCount;
  final String? imageUrl;

  Place({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.contact,
    required this.description,
    required this.lat,
    required this.lng,
    required this.userId,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.imageUrl,
  });

  // Convert Firestore Doc to Place object
  factory Place.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Place(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      address: data['address'] ?? '',
      contact: data['contact'] ?? '',
      description: data['description'] ?? '',
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
      userId: data['userId'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: data['reviewCount'] ?? 0,
      imageUrl: data['imageUrl'],
    );
  }

  // Convert Place object to Map for Firestore
  Map<String, dynamic> toMap() => {
    'name': name,
    'category': category,
    'address': address,
    'contact': contact,
    'description': description,
    'lat': lat,
    'lng': lng,
    'userId': userId,
    'rating': rating,
    'reviewCount': reviewCount,
    'imageUrl': imageUrl,
    'timestamp': FieldValue.serverTimestamp(),
  };
}
