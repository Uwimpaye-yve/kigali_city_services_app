class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});
  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  String _searchQuery = "";
  String _selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kigali City Services")),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(hintText: "Search for a service...", prefixIcon: Icon(Icons.search)),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["All", "Café", "Hospital", "Police", "Park"].map((cat) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: _selectedCategory == cat,
                  onSelected: (selected) => setState(() => _selectedCategory = cat),
                ),
              )).toList(),
            ),
          ),
          // Results List
          Expanded(
            child: StreamBuilder<List<Place>>(
              stream: FirestoreService().getPlaces(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                // Filtering Logic
                final filtered = snapshot.data!.where((p) {
                  bool matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
                  bool matchesCat = _selectedCategory == "All" || p.category == _selectedCategory;
                  return matchesSearch && matchesCat;
                }).toList();

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) => ListTile(
                    title: Text(filtered[i].name),
                    subtitle: Text(filtered[i].address),
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PlaceDetailScreen(place: filtered[i]))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}