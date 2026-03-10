import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/listings_provider.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).user?.uid;
    final listingsProvider = Provider.of<ListingsProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Text("My Listings", style: TextStyle(color: Colors.white)),
      ),
      body: userId == null 
        ? const Center(child: Text("Please log in", style: TextStyle(color: Colors.white70)))
        : listingsProvider.isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.orange))
            : Builder(
                builder: (context) {
                  final myPlaces = listingsProvider.places.where((p) => p.userId == userId).toList();

                  if (myPlaces.isEmpty) {
                    return const Center(child: Text("No listings yet", style: TextStyle(color: Colors.white70)));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: myPlaces.length,
                    itemBuilder: (context, index) {
                      final place = myPlaces[index];
                      return Card(
                        color: const Color(0xFF1A2332),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(place.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text(place.category, style: const TextStyle(color: Colors.white70)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await listingsProvider.deletePlace(place.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Deleted"), backgroundColor: Colors.red),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlaceDetailScreen(place: place)),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}