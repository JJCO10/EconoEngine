import 'package:flutter/material.dart';

class TIRView extends StatelessWidget {
  const TIRView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasa interna de retorno'),
      ),
      body: const Center(
        child: Text('Contenido de la página de Tasa interna de retorno'),
      ),
    );
  }
}