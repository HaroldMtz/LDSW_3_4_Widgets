import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pokemon_service.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final PokemonService service = PokemonService();
  final TextEditingController controller = TextEditingController();
  Map<String, dynamic>? pokemonData;
  bool isLoading = false;

  // ======================================================
  // 🔥 FUNCIÓN PRINCIPAL: Buscar Pokémon + Guardar Firestore
  // ======================================================
  Future<void> fetchPokemon() async {
    if (controller.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Ingresa un nombre")));
      return;
    }

    setState(() => isLoading = true);

    try {
      final data = await service.getPokemon(controller.text.toLowerCase());

      // --------------------------------------------------
      // 🔥 GUARDAR EN FIRESTORE
      // --------------------------------------------------
      await FirebaseFirestore.instance.collection("busquedas").add({
        "nombre": data["name"],
        "altura": data["height"],
        "peso": data["weight"],
        "tipos": data["types"]
            .map((t) => t["type"]["name"])
            .toList(),
        "fecha": DateTime.now(),
      });

      // Mostrar en pantalla
      setState(() => pokemonData = data);

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ======================================================
  // 🔥 INTERFAZ COMPLETA
  // ======================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta Pokémon + Firebase')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de texto
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Ingresa el nombre del Pokémon',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Botón buscar
            ElevatedButton(
              onPressed: fetchPokemon,
              child: const Text('Buscar'),
            ),

            const SizedBox(height: 10),

            // 🔥 Botón historial
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/historial"),
              child: const Text("Ver historial de búsquedas"),
            ),

            const SizedBox(height: 20),

            // Indicador de carga
            if (isLoading) const CircularProgressIndicator(),

            // Resultado del Pokémon
            if (pokemonData != null && !isLoading) ...[
              Image.network(pokemonData!['sprites']['front_default']),

              Text(
                pokemonData!['name'].toString().toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text('Altura: ${pokemonData!['height']}'),
              Text('Peso: ${pokemonData!['weight']}'),

              Text(
                'Tipos: ${pokemonData!['types'].map((t) => t['type']['name']).join(', ')}',
              ),
            ]
          ],
        ),
      ),
    );
  }
}
