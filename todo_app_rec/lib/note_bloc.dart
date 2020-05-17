import './note_event.dart';
import './note_.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteBloc extends Bloc<NoteEvent, List<Note1>> {
  @override
  List<Note1> get initialState => List<Note1>();

  @override
  Stream<List<Note1>> mapEventToState(NoteEvent event) async* {
    switch (event.eventType) {
      case EventType.add:
        List<Note1> newState = List.from(state);
        if (event.note != null) {
          newState.add(event.note);
        }
        yield newState;
        break;
      case EventType.delete:
        List<Note1> newState = List.from(state);
        print(newState.length);
        newState.removeAt(event.noteIndex);
        yield newState;
        break;
      default:
        throw Exception('Event not found $event');
    }
  }
}