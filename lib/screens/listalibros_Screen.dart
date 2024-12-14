import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:prueba02/screens/comentarios_Screen.dart';
import 'package:http/http.dart' as http;

class Listalibros extends StatefulWidget {
  const Listalibros({super.key});

  @override
  _ListalibrosState createState() => _ListalibrosState();
}

class _ListalibrosState extends State<Listalibros> {
  List<dynamic> _librosList = [];

  // Función para obtener los libros desde la API
  Future<void> _fetchLibros() async {
    final response = await http.get(Uri.parse('https://jritsqmet.github.io/web-api/libros.json')); // URL con datos de libros

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _librosList = data['libros']; // Guardamos la lista de libros
      });
    } else {
      print('Error al cargar los datos');
    }
  }

  // Función para mostrar los detalles del libro (solo la descripción) en un AlertDialog
  void _showLibroDetails(String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Descripción del Libro'),
          content: SingleChildScrollView(
            child: Text(description), // Solo la descripción del libro
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchLibros(); // Cargar los libros cuando se inicia la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Libros'),
        backgroundColor: Colors.blueAccent,
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
              title: Text('Recomendaciones'),
              onTap: () {
                if (_librosList.isNotEmpty) {
                  // Seleccionar un libro aleatorio de la lista
                  var libroAleatorio = _librosList[(DateTime.now().millisecondsSinceEpoch % _librosList.length)];

                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Comentarios(
                        bookId: libroAleatorio['id'], 
                        bookTitle: libroAleatorio['titulo'], 
                      ),
                    ),
                  );
                } else {
                  print("No hay libros disponibles");
                }
              },
            ),
          ],
        ),
      ),
      body: _librosList.isEmpty
          ? Center(child: CircularProgressIndicator()) 
          : ListView.builder(
              itemCount: _librosList.length,
              itemBuilder: (context, index) {
                var libro = _librosList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        libro['detalles']['imagen_portada'], 
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      libro['titulo'], 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      libro['género'], 
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                    
                      _showLibroDetails(libro['descripcion']);
                    },
                  ),
                );
              },
            ),
    );
  }
}
