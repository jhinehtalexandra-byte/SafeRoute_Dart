import 'package:flutter/material.dart';
import '../models/models.dart';

class EstudiantesScreen extends StatefulWidget {
  const EstudiantesScreen({super.key});

  @override
  State<EstudiantesScreen> createState() => _EstudiantesScreenState();
}

class _EstudiantesScreenState extends State<EstudiantesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Estudiantes"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Estudiante>>(
        future: _cargarEstudiantes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final estudiantes = snapshot.data ?? [];
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: estudiantes.length,
            itemBuilder: (context, index) {
              final estudiante = estudiantes[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/estudiante.png'),
                  ),
                  title: Text(estudiante.nombre),
                  subtitle: Text("${estudiante.ruta}\n${estudiante.conductor}"),
                  trailing: const Icon(Icons.edit),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioEstudiante(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Estudiante>> _cargarEstudiantes() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Estudiante(nombre: "Ana García", ruta: "Ruta Norte 1", conductor: "Carlos López", imagenPath: ""),
      Estudiante(nombre: "Luis Pérez", ruta: "Ruta Sur 2", conductor: "María González", imagenPath: ""),
      Estudiante(nombre: "Sofía Rodríguez", ruta: "Ruta Centro 3", conductor: "Juan Martínez", imagenPath: ""),
      Estudiante(nombre: "Miguel Torres", ruta: "Ruta Norte 1", conductor: "Carlos López", imagenPath: ""),
    ];
  }

  void _mostrarFormularioEstudiante(BuildContext context) {
    final nombreController = TextEditingController();
    final rutaController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nuevo Estudiante"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: rutaController,
              decoration: const InputDecoration(labelText: "Ruta"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Estudiante ${nombreController.text} agregado")),
              );
              Navigator.pop(context);
            },
            child: const Text("Agregar"),
          ),
        ],
      ),
    );
  }
}
