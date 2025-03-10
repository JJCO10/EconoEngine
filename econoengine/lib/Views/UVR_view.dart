import 'package:flutter/material.dart';

class UVRView extends StatelessWidget {
  const UVRView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unidad de valor real'),
      ),
      body: const Center(
        child: Text('Contenido de la página de Unidad de valor real'),
      ),
    );
  }
}