import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NoteDetailScreen extends StatelessWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    final noteRef = FirebaseDatabase.instance.ref('notes').child(noteId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalles de Gastos",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: noteRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(
              child: Text(
                "Nota no encontrada.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          var note = snapshot.data!.snapshot.value as Map;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shadowColor: Colors.blueAccent.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Row(
                        children: [
                          Icon(Icons.title, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Text(
                            note['title'] ?? 'Sin título',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 1, color: Colors.grey[300]),
                      SizedBox(height: 10),

                      // Descripción
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.description, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              note['description'] ?? 'Sin descripción',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 1, color: Colors.grey[300]),
                      SizedBox(height: 10),

                      // Precio
                      Row(
                        children: [
                          Icon(Icons.monetization_on, color: Colors.green),
                          SizedBox(width: 10),
                          Text(
                            "Precio: \$${note['price'] ?? '0'}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      // Botón de eliminar
                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: Icon(Icons.delete, size: 24),
                          label: Text(
                            "Eliminar Nota",
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            noteRef.remove();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Nota eliminada con éxito"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

