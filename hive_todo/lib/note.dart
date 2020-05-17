import "package:hive/hive.dart";
part 'note.g.dart';

@HiveType(typeId: 0)
class Note{
  @HiveField(0)
  String title;
  @HiveField(1)
  String Description;
  Note(this.title,this.Description);
}