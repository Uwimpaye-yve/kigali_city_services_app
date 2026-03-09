import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/place_model.dart';
import '../../services/firestore_service.dart';
import '../../providers/auth_provider.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String _category = 'Café'; // Default

  void _saveListing() async {
    final userId = Provider.of<AuthProvider>(context, listen: false).user?.uid;
    
    if (_formKey.currentState!.validate() && userId != null) {
      final newPlace = Place(
        id: '', // Firestore generates this automatically
        name: _nameController.text,
        category: _category,
        address: _addressController.text,
        contact: '078XXXXXXX', // Add more fields as needed
        description: 'A great place in Kigali',
        lat: -1.9441, // Replace with actual picker logic later
        lng: 30.1035,
        userId: userId,
      );

      await FirestoreService().addPlace(newPlace);
      Navigator.pop(context); // Go back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Service")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
            DropdownButtonFormField(
              value: _category,
              items: ['Café', 'Hospital', 'Police', 'Park'].map((c) => 
                DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _category = val as String),
            ),
            TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: "Address")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveListing, child: const Text("Save Listing")),
          ],
        ),
      ),
    );
  }
}