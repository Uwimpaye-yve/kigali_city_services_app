import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place_model.dart';
import '../models/review_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // READ all listings for the Directory
  Stream<List<Place>> getPlaces() {
    return _db.collection('listings').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Place.fromFirestore(doc)).toList());
  }

  // CREATE a new listing
  Future<void> addPlace(Place place) {
    return _db.collection('listings').add(place.toMap());
  }

  // UPDATE an existing listing
  Future<void> updatePlace(String id, Map<String, dynamic> data) {
    return _db.collection('listings').doc(id).update(data);
  }

  // DELETE a listing
  Stream<List<Review>> getReviews(String placeId) {
    return _db.collection('reviews')
      .where('placeId', isEqualTo: placeId)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList());
  }

  Future<void> addReview(Review review) async {
    await _db.collection('reviews').add(review.toMap());
    
    final reviews = await _db.collection('reviews')
      .where('placeId', isEqualTo: review.placeId)
      .get();
    
    double avgRating = 0;
    if (reviews.docs.isNotEmpty) {
      avgRating = reviews.docs.map((doc) => (doc.data()['rating'] as num).toDouble())
        .reduce((a, b) => a + b) / reviews.docs.length;
    }
    
    await _db.collection('listings').doc(review.placeId).update({
      'rating': avgRating,
      'reviewCount': reviews.docs.length,
    });
  }

  Future<void> deletePlace(String id) {
    return _db.collection('listings').doc(id).delete();
  }
}