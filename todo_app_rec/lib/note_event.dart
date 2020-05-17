import 'package:hive/hive.dart';
import 'package:todoapprec/note_.dart';
import './main.dart';

enum EventType{add, delete}

class NoteEvent {
  Note1 note;
  int noteIndex;
  EventType eventType;

  NoteEvent();

  NoteEvent.add(Note1 note) {
    this.eventType = EventType.add;
    this.note = note;

  }

  NoteEvent.delete(int index) {
    this.eventType = EventType.delete;
    this.noteIndex = index;
  }

}