import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:myapp/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDb extends ChangeNotifier {
  static late Isar isar;

  // Initialize the database
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  List<Note> currentNotes = [];

  Future<void> addNote(String title, String textFromUser) async {
    // create new note object
    final note = Note()
      ..title = title
      ..content = textFromUser;

    // save note to db
    await isar.writeTxn(() => isar.notes.put(note));

    fetchNotes();   
  }

  Future<Note?> addNoteAndGetById(String title, String textFromUser) async {
    final note = Note()
      ..title = title
      ..content = textFromUser;

    // Guardar la nota en la base de datos
    final noteId = await isar.writeTxn(() => isar.notes.put(note));

    // Recuperar la nota directamente por su ID
    final newNote = await isar.notes.get(noteId);

    // Actualizar la lista de notas
    fetchNotes();

    return newNote;
  }


  void fetchNotes()  {
    // Obtener todas las notas de la base de datos
    currentNotes = isar.notes.where().findAllSync();
  
    // Ordenar en memoria por `id` en orden ascendente
    currentNotes.sort((a, b) => a.id.compareTo(b.id));
  

  }

  Note? getLastAddNote() {
    if (currentNotes.isNotEmpty) {
      return currentNotes.last; // Devuelve la nota más reciente si se ordena en orden ascendente
    }
    return null;
  }

  Future<void> updateNote(int id, String title, String text) async {
    final note = await isar.notes.get(id);
    
    if (note != null) {
      note.title = title;
      note.content = text;
      await isar.writeTxn(() => isar.notes.put(note));
      fetchNotes();
    }
  }

  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    fetchNotes();
  }
}
