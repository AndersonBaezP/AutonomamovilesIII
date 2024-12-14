import 'package:flutter/material.dart';

class Drawer extends StatelessWidget {
  const Drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ComentariosScreen extends StatelessWidget {
  const ComentariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios'),
      ),
      drawer: const Drawer(),
      body: const Center(
        child: Text('Pantalla de Comentarios'),
      ),
    );
  }
}

class SeriesScreen extends StatelessWidget {
  const SeriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Series'),
      ),
      drawer: const Drawer(),
      body: const Center(
        child: Text('Pantalla de Series'),
      ),
    );
  }
}
