import 'package:myapp/models/note.dart';
import 'package:flutter/foundation.dart';

class NoteProvider extends ChangeNotifier {
  Note? _currentNote;

  Note? get currentNote => _currentNote;

  void setCurrentNote(Note? note) {
    _currentNote = note;
    notifyListeners();
  }
}
