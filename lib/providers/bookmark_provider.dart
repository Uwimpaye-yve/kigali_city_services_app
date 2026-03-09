import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Set<String> _bookmarkedPlaceIds = {};

  Set<String> get bookmarkedPlaceIds => _bookmarkedPlaceIds;

  void loadBookmarks(String userId) {
    _db.collection('users').doc(userId).collection('bookmarks').snapshots().listen((snapshot) {
      _bookmarkedPlaceIds = snapshot.docs.map((doc) => doc.id).toSet();
      notifyListeners();
    });
  }

  bool isBookmarked(String placeId) => _bookmarkedPlaceIds.contains(placeId);

  Future<void> toggleBookmark(String userId, String placeId) async {
    final bookmarkRef = _db.collection('users').doc(userId).collection('bookmarks').doc(placeId);
    
    if (isBookmarked(placeId)) {
      await bookmarkRef.delete();
    } else {
      await bookmarkRef.set({'timestamp': FieldValue.serverTimestamp()});
    }
  }

  Stream<List<String>> getBookmarkedPlaceIds(String userId) {
    return _db.collection('users').doc(userId).collection('bookmarks')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }
}
