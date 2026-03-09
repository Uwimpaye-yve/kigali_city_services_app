import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../services/firestore_service.dart';

class ListingsProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<Place> _places = [];
  bool _isLoading = false;
  String? _error;

  List<Place> get places => _places;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void listenToPlaces() {
    _firestoreService.getPlaces().listen(
      (places) {
        _places = places;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> addPlace(Place place) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestoreService.addPlace(place);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePlace(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestoreService.updatePlace(id, data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePlace(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestoreService.deletePlace(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Place> searchAndFilter(String query, String category) {
    return _places.where((place) {
      bool matchesSearch = place.name.toLowerCase().contains(query.toLowerCase());
      bool matchesCategory = category == "Cafés" || 
                            place.category.toLowerCase().contains(category.toLowerCase());
      return matchesSearch && matchesCategory;
    }).toList();
  }
}
