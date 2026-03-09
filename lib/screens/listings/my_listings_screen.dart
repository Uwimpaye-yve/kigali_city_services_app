StreamBuilder<List<Place>>(
  stream: FirestoreService().getMyPlaces(currentUserId), // Filter by current UID
  builder: (context, snapshot) {
    final myPlaces = snapshot.data ?? [];
    return ListView.builder(
      itemCount: myPlaces.length,
      itemBuilder: (context, index) {
        final place = myPlaces[index];
        return ListTile(
          title: Text(place.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: Icon(Icons.edit), onPressed: () => _editListing(place)),
              IconButton(icon: Icon(Icons.delete, color: Colors.red), 
                onPressed: () => FirestoreService().deletePlace(place.id)), // Requirement 2
            ],
          ),
        );
      },
    );
  },
)