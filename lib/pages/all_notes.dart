import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/components/drawer.dart';
import 'package:myapp/components/note_tile.dart';
import 'package:myapp/models/note.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/note_db.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({super.key});

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  // controller for acess user input
  final textController = TextEditingController();
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // when app startup read notes from database
    readNotes();
  }

  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          autofocus: true,
          controller: textController,
          decoration: const InputDecoration(hintText: 'Enter a new note'),
        ),
        title: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Title'),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context
                  .read<NoteDb>()
                  .addNote(titleController.text, textController.text);
              // close the dialog
              titleController.clear();
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text('Save Note'),
          ),
        ],
      ),
    );
  }

  void readNotes() {
    context.read<NoteDb>().fetchNotes();
  }

  void updateNotes(Note note) {
    textController.text = note.content;
    titleController.text = note.title;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                autofocus: true,
                controller: textController,
                decoration: const InputDecoration(hintText: 'Edit Note'),
              ),
              title: TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      context.read<NoteDb>().updateNote(
                          note.id, titleController.text, textController.text);
                      titleController.clear();
                      textController.clear();
                      Navigator.pop(context);
                      readNotes();
                    },
                    child: const Text('Update Note'))
              ],
            ));
  }

  void deleteNotes(int id) {
    context.read<NoteDb>().deleteNote(id);
    readNotes();
  }

  @override
  Widget build(BuildContext context) {
    final noteDb = context.watch<NoteDb>();
    // read all notes from database
    List<Note> currentNotes = noteDb.currentNotes;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        floatingActionButton: FloatingActionButton(
          onPressed: createNote,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
        drawer: const MyDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // heading
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text('All Notes',
                  style: GoogleFonts.dmSerifText(
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  )),
            ),

            // list of notes
            Expanded(
              child: ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  final note = currentNotes[index];

                  return NoteTile(
                    title: note.title,
                    content: note.content,
                    onEditPressed: () => updateNotes(note),
                    onDeletePressed: () => deleteNotes(note.id),
                  );
                },
              ),
            ),
          ],
        )
      );
  }
}
