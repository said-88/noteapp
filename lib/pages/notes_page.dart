import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/components/drawer.dart';
import 'package:myapp/components/note_tile.dart';
import 'package:myapp/models/note.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/note_db.dart';
import 'package:myapp/pages/page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // controller for acess user input
  final textController = TextEditingController();
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // when app startup read notes from database
    readNotes();
  }

  // read all notes from database
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
                    },
                    child: const Text('Update Note'))
              ],
            ));
  }

  void deleteNotes(int id) {
    context.read<NoteDb>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    final noteDb = context.watch<NoteDb>();

    List<Note> currentNotes = noteDb.currentNotes;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        // createNote button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyPage(isNew: true)),
            );
          },
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
                scrollDirection: Axis.vertical,
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  final note = currentNotes[index];

                  return NoteTile(
                    title: note.title,
                    content: note.content,
                    onEditPressed: () => updateNotes(note),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyPage(note: note)),
                      );
                    },
                    onDeletePressed: () => deleteNotes(note.id),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
