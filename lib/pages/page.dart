import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/note.dart';
import 'package:myapp/models/note_db.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  final Note? note;
  final bool isNew;

  const MyPage({
    super.key,
    this.note,
    this.isNew = false
  });
  
  @override
  State<MyPage> createState() => _PageState();
}

class _PageState extends State<MyPage> {
  // controller for acess user input
  final textController = TextEditingController();
  final titleController = TextEditingController();
  final titleFocusNode = FocusNode();
  final textFocusNode = FocusNode();
  bool noteSaved = false;
  bool isFocused = false;
  Note? currentNote; 

  @override
  void initState() {
    super.initState();
    titleFocusNode.addListener(_focusListener);
    textFocusNode.addListener(_focusListener);

     // Inicializa los controladores de texto si se está editando una nota
    if (!widget.isNew && widget.note != null) {
      titleController.text = widget.note!.title;
      textController.text = widget.note!.content;
      currentNote = widget.note;
    }
  }

  @override
  void dispose() {
    titleFocusNode.removeListener(_focusListener);
    textFocusNode.removeListener(_focusListener);
    titleFocusNode.dispose();
    textFocusNode.dispose();
    titleFocusNode.dispose();
    textFocusNode.dispose();
    super.dispose();
  }

  void _focusListener() {
    setState(() {
      isFocused = titleFocusNode.hasFocus || textFocusNode.hasFocus;
    });
  }

    // saveNewNote and saveEditNote
    void saveNote() async {
      final title = titleController.text;
      final text = textController.text;
      final noteDb = context.read<NoteDb>();

      if (title.isNotEmpty || text.isNotEmpty) {
        if (widget.isNew && currentNote == null) {
          // Crear nueva nota
          await noteDb.addNote(title, text);
        currentNote = noteDb.getLastAddNote();
        } else if (currentNote != null) {
          // Actualizar nota existente
          await noteDb.updateNote(currentNote!.id, title, text);
        }

        setState(() {
          noteSaved = true;
          isFocused = false; // Oculta el botón al guardar la nota

        });
        // Quita el foco de los campos de texto
        if (mounted) {
          FocusScope.of(context).unfocus();
        }
      }     
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text('Note',
                style: GoogleFonts.dmSerifText(
                  fontWeight: FontWeight.bold,
                  fontSize: 38,
                  color: Theme.of(context).colorScheme.inversePrimary,
                )),
          ),
          // create or edit note
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: titleController,
              focusNode: titleFocusNode,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              maxLength: 100, // Optional: Limit the title length
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: TextField(
              autofocus: true,
              controller: textController,
              focusNode: textFocusNode,
              decoration: const InputDecoration(
                hintText: 'Enter a new note',
                border: InputBorder.none,
              ),
              maxLines: null, // Allows for multiple lines
            ),
          ),
          const SizedBox(height: 16),

          if (!noteSaved || isFocused)
            Padding(
              padding: const EdgeInsets.only(left: 130.0),
              child: ElevatedButton(
                onPressed: saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: const Text('Save Note'),
              ),
            ),
        ],
      ),
    );
  }
}
