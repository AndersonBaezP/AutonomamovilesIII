import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:prueba02/screens/listalibros_Screen.dart'; 

class Comentarios extends StatefulWidget {
  final String bookId;
  final String bookTitle;

  const Comentarios({super.key, required this.bookId, required this.bookTitle});

  @override
  _ComentariosState createState() => _ComentariosState();
}

class _ComentariosState extends State<Comentarios> {
  final TextEditingController _idController = TextEditingController(); 
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _generoController = TextEditingController(); 
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> _guardarComentario() async {
    final String recomendacionId = _idController.text.trim(); 
    final String comentario = _comentarioController.text.trim();
    final String genero = _generoController.text.trim();

    
    if (recomendacionId.isNotEmpty && comentario.isNotEmpty && genero.isNotEmpty) {
      
      DatabaseReference comentariosRef = _database.ref('comentarios/$recomendacionId');
      await comentariosRef.set({
        'recomendacionId': recomendacionId,  
        'libroId': widget.bookId,            
        'titulolibro': widget.bookTitle,     
        'genero': genero,                    
        'comentario': comentario,            
      });

      // Limpiar los campos de texto
      _idController.clear();
      _comentarioController.clear();
      _generoController.clear(); 

      _showSuccessDialog(); // Mostrar mensaje de éxito
    } else {
      _showErrorDialog(); // Mostrar mensaje de error
    }
  }

  // Función para mostrar un diálogo de éxito
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comentario guardado'),
          content: Text('Tu comentario ha sido guardado exitosamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar un diálogo de error
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Por favor, ingresa todos los campos.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios sobre "${widget.bookTitle}"'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Lista de Libros'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Listalibros()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo para el ID de la recomendación
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'ID de la recomendación',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Campo para el comentario
            TextField(
              controller: _comentarioController,
              decoration: InputDecoration(
                labelText: 'Comentario',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            // Campo para el género
            TextField(
              controller: _generoController,
              decoration: InputDecoration(
                labelText: 'Género',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Botón para guardar el comentario
            ElevatedButton(
              onPressed: _guardarComentario,
              child: Text('Guardar Comentario'),
            ),
            SizedBox(height: 16),
            // Botón para volver a la lista de libros
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Listalibros()),
                );
              },
              child: Text('Volver a la Lista de Libros'),
            ),
          ],
        ),
      ),
    );
  }
}
