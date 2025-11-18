import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pokemon_screen.dart';
import 'historial_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokémon + Firebase',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const PokemonScreen(),
      routes: {
        "/historial": (_) => const HistorialScreen(),
      },
    );
  }
}
