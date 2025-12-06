// lib/models/models.dart
class Estudiante {
  final String nombre;
  final String ruta;
  final String conductor;
  final String imagenPath;

  Estudiante({
    required this.nombre,
    required this.ruta,
    required this.conductor,
    required this.imagenPath,
  });
}

class Ruta {
  final String nombre;
  final int estudiantes;
  final String hora;
  final String estado;

  Ruta({
    required this.nombre,
    required this.estudiantes,
    required this.hora,
    required this.estado,
  });
}
