import 'package:flutter/material.dart';

class InteresSimpleView extends StatelessWidget {
  const InteresSimpleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interés Simple'),
      ),
      body: const Center(
        child: Text('Contenido de la página de Interés Simple'),
      ),
    );
  }
}