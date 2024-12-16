import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:prueba02/screens/AuthService.dart';
import 'package:prueba02/screens/WelcomeScreen.dart';
import 'package:prueba02/screens/NotesListScreen.dart';
import 'package:prueba02/screens/CreateNoteScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'Notas de Gastos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/', // Ruta inicial
        routes: {
          '/': (context) => WelcomeScreen(),
          '/notes': (context) => NotesListScreen(),
          '/createNote': (context) => CreateNoteScreen(),
        },
      ),
    );
  }
}
