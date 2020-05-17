import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import './note.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Opening Directory");
  final directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NoteAdapter());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Recruitment Task",
        home: FutureBuilder(
            future: Hive.openBox('notes'),
            builder: (BuildContext context,AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done){
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                else {
                  print("opened box");
                  return Todo();
                }
              }
              else {
                return Scaffold();
              }
            }
        )
    );
  }
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}

class Todo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TodoState();
  }
}

class _TodoState extends State<Todo> {

  var index;
  String _task= 'Add';
  Color _iconColor= Colors.red;
  var _currentItemSelected= 'Incomplete';
  var _options= ['Incomplete','Complete','Delete'];
  TextEditingController Titlecontroller=TextEditingController();
  TextEditingController Desccontroller=TextEditingController();
  DateTime _dateTime=DateTime.now();

  void addItem(Note note) {
    final noteBox = Hive.box('notes');
    noteBox.add(note);
    print("adding itmes");
  }
  void Update(Note note) {
    final noteBox = Hive.box('notes');
    noteBox.putAt(index,note);
    print("adding itmes");
  }


  @override
  Widget build(BuildContext context) {
    String _currentDate = new DateFormat.yMMMd().format(_dateTime);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo List"),
        backgroundColor: Colors.deepOrangeAccent,
        bottom: PreferredSize(child: Text("$_currentDate", style: TextStyle(color: Colors.white.withOpacity(1.0)))),

      ),
      body: todoList(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              _task='Add';
              if(index==null){
                Titlecontroller.text= '';
                Desccontroller.text= '';
              }
              else{
                final noteBox = Hive.box('notes');
                Titlecontroller.text= noteBox.getAt(index).title;
                Desccontroller.text= noteBox.getAt(index).description;
              }
              addItemDialog();
            });
          }
      ),
    );
  }
  todoList() {

    return ValueListenableBuilder(
        valueListenable:Hive.box('notes').listenable(),
        builder: (context, Box notes, _) {
          print("Added item to List View");


          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context,index)
            {return Card(
                elevation: 6.0,
                child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: _iconColor,
                        child: Icon(Icons.arrow_forward_ios)
                    ),
                    subtitle: Text(notes.getAt(index).description),
                    title: Text(notes.getAt(index).title),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                          notes.deleteAt(index);
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Successfully Deleted")));
                      },
                    ),

                    onLongPress:() {
                      setState(() {
                          if(index==null){
                            Titlecontroller.text= '';
                            Desccontroller.text= '';
                          }
                          else{
                            final noteBox = Hive.box('notes');
                            Titlecontroller.text= noteBox.getAt(index).title;
                            Desccontroller.text= noteBox.getAt(index).description;
                            _task='Update';
                          }
                          addItemDialog();
                          notes.deleteAt(index);

                      });
                    },
                    onTap: () {

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  content: SingleChildScrollView(child: Column(
                                      children: <Widget>[
                                        DropdownButton<String> (
                                          items: _options.map((String dropDownStringItem){
                                            return DropdownMenuItem<String>(
                                              value: dropDownStringItem,
                                              child: Text(dropDownStringItem),
                                            );
                                          }).toList(),
                                          onChanged: (String newValueSelected) {
                                            setState(() {
                                              this._currentItemSelected=newValueSelected;
                                            });
                                          },
                                          value: _currentItemSelected,
                                        ),
                                        RaisedButton(
                                          child: Text("Done"),
                                          onPressed: () {

                                            if(_currentItemSelected=='Delete'){
                                              notes.deleteAt(index);
                                              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Successfully Deleted")));
                                            }
                                            if(_currentItemSelected=='Complete'){
                                              notes.deleteAt(index);
                                              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Successfully Deleted")));
                                            }
                                            if(_currentItemSelected=='Incomplete'){

                                            }
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ]
                                  ))
                              );
                            }
                        );

                    }
                ),
              );
            },
          );
        }
    );
  }

  addItemDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SingleChildScrollView(child: Column(
                  children: <Widget>[
                    TextField(
                      controller: Titlecontroller,
                      decoration: InputDecoration(
                          hintText: "Enter Agenda",
                          labelText: "Enter a Task"
                      ),
                    ),
                    TextField(
                      controller: Desccontroller,
                      decoration: InputDecoration(
                          hintText: "Eg. To be done at 6pm",
                          labelText: "Enter the Description"
                      ),
                    ),
                    SizedBox(
                        height: 10.0
                    ),
                    DropdownButton<String> (
                      items: _options.map((String dropDownStringItem){
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      onChanged: (String newValueSelected) {
                        setState(() {
                          this._currentItemSelected=newValueSelected;
                        });
                      },
                      value: _currentItemSelected,
                    ),
                    RaisedButton(
                      child: Text("Clear"),
                      onPressed: () {
                        setState(() {
                          Titlecontroller.text= '';
                          Desccontroller.text= '';
                        });
                      },
                    ),
                    RaisedButton(
                      child: Text("$_task"),
                      onPressed: () {

                        addItem(Note(Titlecontroller.text,Desccontroller.text));
                        Navigator.pop(context);
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Successfully Added")));

                      },
                    )
                  ]
              ))
          );
        }
    );
  }
}