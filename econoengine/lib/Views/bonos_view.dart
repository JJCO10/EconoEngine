import 'package:flutter/material.dart';

class BonosView extends StatelessWidget {
  const BonosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bonos'),
      ),
      body: const Center(
        child: Text('Contenido de la página de Bonos'),
      ),
    );
  }
}