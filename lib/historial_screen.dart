import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Búsquedas"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("busquedas")
            .orderBy("fecha", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No hay búsquedas todavía."),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();

              final nombre = data["nombre"] ?? "Desconocido";
              final altura = data["altura"]?.toString() ?? "?";
              final peso = data["peso"]?.toString() ?? "?";
              final tipos = (data["tipos"] as List?)?.join(", ") ?? "N/A";

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    nombre.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Altura: $altura • Peso: $peso \nTipos: $tipos",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
