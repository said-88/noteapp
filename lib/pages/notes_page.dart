import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/components/draggable_note.dart';
import 'package:myapp/components/drawer.dart';
import 'package:myapp/models/note_db.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/note.dart';
import 'package:provider/provider.dart';
import 'package:myapp/pages/page.dart';
import 'dart:ui';

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
    // 
    Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(animation: animation, builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 10, animValue)!;

        return Material(
          elevation: elevation,
          color: Theme.of(context).colorScheme.primary,
          shadowColor: Theme.of(context).colorScheme.secondary,          
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
              boxShadow:  [
                BoxShadow(
                  color: Theme.of(context).colorScheme.secondary, 
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
        child: child,
      );
    }

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
            Flexible(
              child: Scrollbar(
                thickness: 10,
                radius: const Radius.circular(10),
                child: ReorderableListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  proxyDecorator: proxyDecorator,
                  onReorder: (oldIndex, newIndex) {
                   setState(() {
                      if (oldIndex < newIndex) {
                        newIndex--;
                      }
                      final Note item = currentNotes.removeAt(oldIndex);
                      currentNotes.insert(newIndex, item);
                   });
                  },
                
                  children: [
                    for (final note in currentNotes)
                      ReorderableDragStartListener(
                        index: currentNotes.indexOf(note),
                        key: ValueKey(note.id),
                        child: DraggableNotile(
                          key: ValueKey(note.id),
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
                          isDragging: false,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
