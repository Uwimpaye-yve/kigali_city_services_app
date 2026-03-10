import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/bookmark_provider.dart';
import 'providers/listings_provider.dart'; 
import 'screens/auth/wrapper.dart'; 
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const KigaliDirectoryApp());
}

class KigaliDirectoryApp extends StatelessWidget {
  const KigaliDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => ListingsProvider()..listenToPlaces()),
      ],
      child: MaterialApp(
        title: 'Kigali Directory',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.orange, 
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}