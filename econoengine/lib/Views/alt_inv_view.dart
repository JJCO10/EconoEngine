import 'package:flutter/material.dart';

class AlternativasInversionView extends StatelessWidget {
  const AlternativasInversionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alternativas de Inversión'),
      ),
      body: const Center(
        child: Text('Contenido de la página de Alternativas de Inversión'),
      ),
    );
  }
}