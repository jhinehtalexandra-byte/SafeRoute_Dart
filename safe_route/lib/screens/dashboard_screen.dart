// lib/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../models/models.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SafeRoute Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () => Navigator.pushNamed(context, '/estudiantes'),
          ),
          IconButton(
            icon: const Icon(Icons.route),
            onPressed: () => Navigator.pushNamed(context, '/rutas'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Container decorado para búsqueda
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Buscar estudiantes o rutas...",
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
          
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _cargarDatosDashboard(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final estudiantes = snapshot.data?[0] as List<Estudiante>? ?? [];
                final rutas = snapshot.data?[1] as List<Ruta>? ?? [];

                final estudiantesFiltrados = estudiantes
                    .where((e) => e.nombre.toLowerCase().contains(_filtro.toLowerCase()))
                    .toList();

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildStatsRow(context),
                    const SizedBox(height: 20),
                    
                    const Text(
                      "Rutas Activas",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: rutas.length,
                        itemBuilder: (context, index) {
                          final ruta = rutas[index];
                          return Container(
                            width: 280,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(ruta.nombre, 
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: ruta.estado == 'Activa' ? Colors.green : Colors.orange,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(ruta.estado, style: const TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text("Estudiantes: ${ruta.estudiantes}", 
                                      style: const TextStyle(fontSize: 14)),
                                  Text("Hora: ${ruta.hora}", style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Text("Estudiantes (${estudiantesFiltrados.length})", 
                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: estudiantesFiltrados.length,
                      itemBuilder: (context, index) {
                        final estudiante = estudiantesFiltrados[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundImage: AssetImage('assets/images/estudiante.png'),
                              child: Icon(Icons.person),
                            ),
                            title: Text(estudiante.nombre),
                            subtitle: Text("${estudiante.ruta} - ${estudiante.conductor}"),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () => _mostrarDetalleEstudiante(context, estudiante),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: _StatCard(
            icon: Icons.people,
            title: "342",
            subtitle: "Estudiantes",
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: _StatCard(
            icon: Icons.route,
            title: "24",
            subtitle: "Rutas",
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: _StatCard(
            icon: Icons.warning,
            title: "7",
            subtitle: "Alertas",
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  void _mostrarDetalleEstudiante(BuildContext context, Estudiante estudiante) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(estudiante.nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/estudiante.png'),
              child: Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            Text("Ruta: ${estudiante.ruta}"),
            Text("Conductor: ${estudiante.conductor}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> _cargarDatosDashboard() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      // Estudiantes
      [
        Estudiante(nombre: "Ana García", ruta: "Ruta Norte 1", conductor: "Carlos López", imagenPath: ""),
        Estudiante(nombre: "Luis Pérez", ruta: "Ruta Sur 2", conductor: "María González", imagenPath: ""),
        Estudiante(nombre: "Sofía Rodríguez", ruta: "Ruta Centro 3", conductor: "Juan Martínez", imagenPath: ""),
      ],
      // Rutas
      [
        Ruta(nombre: "Ruta Norte 1", estudiantes: 25, hora: "08:15 AM", estado: "Activa"),
        Ruta(nombre: "Ruta Sur 2", estudiantes: 18, hora: "08:30 AM", estado: "Programada"),
        Ruta(nombre: "Ruta Centro 3", estudiantes: 22, hora: "08:45 AM", estado: "Activa"),
      ]
    ];
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      ),
    );
  }
}
