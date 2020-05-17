import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note{
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final DateTime date;

  Note(this.title, this.description, this.date);
}