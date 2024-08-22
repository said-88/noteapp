import 'package:flutter/material.dart';
import 'package:myapp/models/note_db.dart';
import 'package:myapp/models/note_provider.dart';
//import 'package:myapp/pages/all_notes.dart';
import 'package:myapp/pages/notes_page.dart';
import 'package:myapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // initialize isar database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDb.init();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => NoteDb()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => NoteProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // todo: cambiar el home a AllNotes
      home: const NotesPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}