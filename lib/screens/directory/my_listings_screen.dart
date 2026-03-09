import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/place_model.dart';
import '../../services/firestore_service.dart';
import '../../providers/auth_provider.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID from our AuthProvider
    final userId = Provider.of<AuthProvider>(context).user?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("My Listings")),
      body: userId == null 
        ? const Center(child: Text("Please log in to see your listings"))
        : StreamBuilder<List<Place>>(
            // Use the stream but filter for this user's UID
            stream: FirestoreService().getPlaces(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Filter the list to only show items created by THIS user
              final myPlaces = snapshot.data?.where((p) => p.userId == userId).toList() ?? [];

              if (myPlaces.isEmpty) {
                return const Center(child: Text("You haven't added any places yet."));
              }

              return ListView.builder(
                itemCount: myPlaces.length,
                itemBuilder: (context, index) {
                  final place = myPlaces[index];
                  return ListTile(
                    title: Text(place.name),
                    subtitle: Text(place.category),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // UPDATE: Requirement 2
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // TODO: Navigate to an Edit Screen
                          },
                        ),
                        // DELETE: Requirement 2
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await FirestoreService().deletePlace(place.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Listing deleted"))
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}