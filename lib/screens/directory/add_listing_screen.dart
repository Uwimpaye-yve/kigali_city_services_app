import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/place_model.dart';
import '../../providers/listings_provider.dart';
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
  final _contactController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _category = 'Café';

  void _saveListing() async {
    final userId = Provider.of<AuthProvider>(context, listen: false).user?.uid;
    
    if (_formKey.currentState!.validate() && userId != null) {
      final newPlace = Place(
        id: '',
        name: _nameController.text,
        category: _category,
        address: _addressController.text,
        contact: _contactController.text,
        description: _descriptionController.text,
        lat: -1.9441,
        lng: 30.1035,
        userId: userId,
        rating: 0.0,
        reviewCount: 0,
      );

      await Provider.of<ListingsProvider>(context, listen: false).addPlace(newPlace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing created!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Text('Add New Service', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              dropdownColor: const Color(0xFF1A2332),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              items: ['Café', 'Pharmacy', 'Hospital', 'Park', 'Police'].map((c) => 
                DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Contact',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: _saveListing,
                child: const Text('Save Listing', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}