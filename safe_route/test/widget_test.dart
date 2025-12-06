// test/widget_test.dart ← COPIAR ESTE CÓDIGO EXACTO
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_route/main.dart';
// IMPORTS NECESARIOS para tests
import 'package:safe_route/screens/inicio_screen.dart';

void main() {
  testWidgets('SafeRoute loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SafeRouteApp());

    // Verify that MaterialApp loads
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Verify InicioScreen loads (primera pantalla)
    expect(find.byType(InicioScreen), findsOneWidget);
    
    // Verify app title appears
    expect(find.textContaining('SafeRoute'), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
  });
}
