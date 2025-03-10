import 'package:flutter/material.dart';

class AmortizacionView extends StatelessWidget {
  const AmortizacionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amortización'),
      ),
      body: const Center(
        child: Text('Contenido de la página de Amortización'),
      ),
    );
  }
}