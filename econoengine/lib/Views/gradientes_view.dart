import 'package:flutter/material.dart';

class GradientesView extends StatelessWidget {
  const GradientesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gradientes'),
      ),
      body: const Center(
        child: Text('Contenido de la página de Gradientes'),
      ),
    );
  }
}