import 'package:flutter/material.dart';

class InflacionView extends StatelessWidget {
  const InflacionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inflacion'),
      ),
      body: const Center(
        child: Text('Contenido de la página de Inflacion'),
      ),
    );
  }
}