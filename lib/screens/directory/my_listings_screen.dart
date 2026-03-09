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
      appBar: AppBar(title: const Text("My Listings")),
      body: userId == null 
        ? const Center(child: Text("Please log in to see your listings"))
        : listingsProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Builder(
                builder: (context) {
                  final myPlaces = listingsProvider.places
                      .where((p) => p.userId == userId)
                      .toList();

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
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await listingsProvider.deletePlace(place.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Listing deleted"))
                                  );
                                }
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