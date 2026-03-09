import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String placeId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Review(
      id: doc.id,
      placeId: data['placeId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonymous',
      rating: (data['rating'] as num).toDouble(),
      comment: data['comment'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'placeId': placeId,
    'userId': userId,
    'userName': userName,
    'rating': rating,
    'comment': comment,
    'timestamp': FieldValue.serverTimestamp(),
  };
}
