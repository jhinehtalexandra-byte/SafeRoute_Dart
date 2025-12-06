import 'package:flutter/material.dart';
import '../models/models.dart';

class RutasScreen extends StatefulWidget {
  const RutasScreen({super.key});

  @override
  State<RutasScreen> createState() => _RutasScreenState();
}

class _RutasScreenState extends State<RutasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rutas Escolares"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Nueva Ruta"),
                    onPressed: () => _nuevaRuta(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Ruta>>(
                future: _cargarRutas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final rutas = snapshot.data ?? [];
                  
                  return ListView.builder(
                    itemCount: rutas.length,
                    itemBuilder: (context, index) {
                      final ruta = rutas[index];
                      return Dismissible(
                        key: ValueKey(ruta.nombre),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${ruta.nombre} eliminada")),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: const Icon(Icons.route, color: Colors.amber),
                            title: Text(ruta.nombre),
                            subtitle: Text("${ruta.estudiantes} estudiantes • ${ruta.hora}"),
                            trailing: Chip(
                              label: Text(ruta.estado),
                              backgroundColor: ruta.estado == 'Activa' 
                                  ? Colors.green : Colors.orange,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Ruta>> _cargarRutas() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Ruta(nombre: "Ruta Norte 1", estudiantes: 25, hora: "08:15 AM", estado: "Activa"),
      Ruta(nombre: "Ruta Sur 2", estudiantes: 18, hora: "08:30 AM", estado: "Programada"),
      Ruta(nombre: "Ruta Centro 3", estudiantes: 22, hora: "08:45 AM", estado: "Activa"),
      Ruta(nombre: "Ruta Este 4", estudiantes: 20, hora: "09:00 AM", estado: "Programada"),
    ];
  }

  void _nuevaRuta(BuildContext context) {
    final nombreController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nueva Ruta"),
        content: TextField(
          controller: nombreController,
          decoration: const InputDecoration(labelText: "Nombre de la ruta"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Ruta ${nombreController.text} creada")),
              );
              Navigator.pop(context);
            },
            child: const Text("Crear"),
          ),
        ],
      ),
    );
  }
}
