import 'package:flutter/material.dart';

// Modelo de datos simple
class Personaje {
  final String nombre;
  final String trabajo;
  final String descripcion;
  final String imagenPath;

  Personaje({
    required this.nombre,
    required this.trabajo,
    required this.descripcion,
    required this.imagenPath,
  });
}

void main() {
  runApp(const SpringfieldApp());
}

class SpringfieldApp extends StatelessWidget {
  const SpringfieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Springfield Wiki',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        scaffoldBackgroundColor: Colors.yellow[50], // Tono suave de fondo
      ),
      home: const ListaPersonajesScreen(),
    );
  }
}

class ListaPersonajesScreen extends StatefulWidget {
  const ListaPersonajesScreen({super.key});

  @override
  State<ListaPersonajesScreen> createState() => _ListaPersonajesScreenState();
}

class _ListaPersonajesScreenState extends State<ListaPersonajesScreen> {
  // CONCEPTO 3: TextField y Controller
  // Usamos el controller para escuchar lo que el usuario escribe
  final TextEditingController _searchController = TextEditingController();
  String _filtro = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _filtro = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Simulación de base de datos local
  Future<List<Personaje>> _obtenerPersonajes() async {
    // CONCEPTO 7: FutureBuilder (Simulamos retardo de red/base de datos)
    await Future.delayed(const Duration(seconds: 2));

    return [
      Personaje(
        nombre: "Homer Simpson",
        trabajo: "Inspector de Seguridad",
        descripcion: "Amante de las donas y la cerveza Duff.",
        imagenPath: "assets/images/homer.jpg",
      ),
      Personaje(
        nombre: "Marge Simpson",
        trabajo: "Ama de casa",
        descripcion:
            "La paciencia hecha persona. Reconocible por su cabello azul.",
        imagenPath: "assets/images/marge.png",
      ),
      Personaje(
        nombre: "Bart Simpson",
        trabajo: "Estudiante",
        descripcion: "El chico malo de la escuela primaria de Springfield.",
        imagenPath: "assets/images/bart.jpg",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personajes de Springfield")),
      body: Column(
        children: [
          // CONCEPTO 5: Container (Decoración)
          // Usamos Container para dar estilo al área de búsqueda
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.yellow,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            // CONCEPTO 3: TextField
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Buscar personaje...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // CONCEPTO 1: Expanded (Para que la lista ocupe el resto del espacio)
          Expanded(
            // CONCEPTO 7: FutureBuilder
            child: FutureBuilder<List<Personaje>>(
              future: _obtenerPersonajes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No hay datos"));
                }

                // Filtrar la lista según el buscador
                final listaFiltrada = snapshot.data!.where((p) {
                  return p.nombre.toLowerCase().contains(_filtro.toLowerCase());
                }).toList();

                // CONCEPTO 4: ListView.builder
                return ListView.builder(
                  itemCount: listaFiltrada.length,
                  itemBuilder: (context, index) {
                    final personaje = listaFiltrada[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        // CONCEPTO 6: Assets
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(personaje.imagenPath),
                          // Si no tienes assets configurados, usa: NetworkImage('url')
                        ),
                        title: Text(personaje.nombre),
                        subtitle: Text(personaje.trabajo),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // CONCEPTO 2: Navigator
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetallePersonajeScreen(personaje: personaje),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetallePersonajeScreen extends StatelessWidget {
  final Personaje personaje;

  const DetallePersonajeScreen({super.key, required this.personaje});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(personaje.nombre)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // CONCEPTO 6: Assets (Imagen grande)
            // CONCEPTO 5: Container (Decoración de imagen)
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.yellow[200],
                image: DecorationImage(
                  image: AssetImage(personaje.imagenPath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CONCEPTO 1: Row (Para alinear icono y texto)
                  Row(
                    children: [
                      const Icon(Icons.work, color: Colors.blueGrey),
                      const SizedBox(width: 8),
                      Text(
                        personaje.trabajo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Descripción",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    personaje.descripcion,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  // CONCEPTO 2: Navigator (Botón para volver)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Volver a la lista"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
