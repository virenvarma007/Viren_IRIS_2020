import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import './note_.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './note_bloc.dart';
import './note_bloc_delegate.dart';
import 'bloc.dart';
import 'note.dart';
import 'package:table_calendar/table_calendar.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Opening Directory");
  final directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NoteAdapter());
  BlocSupervisor.delegate = NoteBlocDelegate();
  print('Connecting Bloc_delegate or is mosting called state');
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
    return BlocProvider<NoteBloc>(
        create: (context) => NoteBloc(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Recruitment Task",
            home: FutureBuilder(
                future: Hive.openBox('notes'),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      print("opened box");
                      print('Connect note_bloc');
                      return Todo();
                    }
                  } else {
                    return Scaffold();
                  }
                })));
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
    print('Hive Close');
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
  CalendarController _controller;
  DateTime _tcal;

  int x = 0;
  var index;
  String _task = 'Add';
  Color _iconColor = Colors.red;
  var _currentItemSelected = 'Incomplete';
  var _options = ['Incomplete', 'Complete', 'Delete'];
  TextEditingController Titlecontroller = TextEditingController();
  TextEditingController Desccontroller = TextEditingController();
  DateTime _dateTime = DateTime.now();

  Future<Null> _handleDatePicker(BuildContext context) async {
    final DateTime _dateResult = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2001),
        lastDate: DateTime(2222));
    if (_dateResult != null) {
      setState(() {
        _dateTime = _dateResult;
        print('Date is now $_dateTime');
      });
    }
  }

  void addItem(Note note) {
    final noteBox = Hive.box('notes');
    noteBox.add(note);
    print("items Added");
  }

  int m = 0;
  String _instruction = '(Press Reload to See Saved List)';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  @override
  void initState() {
    super.initState();
    initializing();
    print('Initialise Notifications');
    _controller = CalendarController();
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> _showconfirmer(String title3, DateTime date3) async {
    await confirmer(title3, date3);
    print('Confirmer Appears');
  }

  Future<void> confirmer(String title4, DateTime date4) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'Channel ID', 'Channel title', 'channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(0, 'Todo Item Confirmer',
        'You will be notified about $title4 on $date4', notificationDetails);
  }

  void _showNotifications(String title1, String desc1, DateTime date1) async {
    await notification(title1, desc1, date1);
    print('Reminder Appears');
  }

  Future<void> notification(String title2, String desc2, DateTime date2) async {
    var time = Time(7, 0, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0, '$date2: $title2', '$desc2', time, platformChannelSpecifics);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }

    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String _currentDate = new DateFormat.yMMMd().format(_dateTime);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Tooltip(
              message: 'Tap Icon to start',
              child: IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      _instruction = '';
                    });
                    if (m == 0) {
                      final noteBox = Hive.box('notes');
                      for (int i = 1; i < noteBox.length; i++) {
                        BlocProvider.of<NoteBloc>(context).add(
                          NoteEvent.add(
                            Note1(
                                noteBox.getAt(i).title,
                                noteBox.getAt(i).description,
                                noteBox.getAt(i).date,
                                noteBox.getAt(i).status),
                          ),
                        );
                        _showNotifications(
                            noteBox.getAt(i).title,
                            noteBox.getAt(i).description,
                            noteBox.getAt(i).date);
                      }
                      m++;
                      print('App Reloaded');
                    }
                  }))
        ],
        title: Text("ToDo List"),
        backgroundColor: Colors.deepOrangeAccent,
        leading: Tooltip(
            message: 'Tap for Info',
            child: IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title:
                                Text("Here's Info on how to operate the app"),
                            content: SingleChildScrollView(
                                child: Column(children: <Widget>[
                              Text(
                                  'Reload Icon: Loads the list n gets the App started \n\nCalendar: use Calendar to set overall date\n\nRed Leading Icon on List: Sets the overall date to that items date to make it visible\n\nOnLongPress of ListTile: Updates the particular item\n\n OnTap of ListTile: Sets the status of item \n\nDelete icon on ListTile: Deletes Item'),
                              SizedBox(height: 15.0),
                              RaisedButton(
                                  child: Text('Back'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ])));
                      });
                })),
        bottom: PreferredSize(
            child: Text("$_currentDate $_instruction ",
                style: TextStyle(color: Colors.white.withOpacity(1.0)))),
      ),
      body: todoList(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              _task = 'Add';
              Titlecontroller.text = '';
              Desccontroller.text = '';
              addItemDialog();
            });
          }),
    );
  }

  todoList() {
    return Column(children: <Widget>[
      TableCalendar(
        initialCalendarFormat: CalendarFormat.week,
        calendarStyle: CalendarStyle(
            todayColor: Colors.orange,
            selectedColor: Theme.of(context).primaryColor,
            todayStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white)),
        headerStyle: HeaderStyle(
          centerHeaderTitle: true,
          formatButtonDecoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20.0),
          ),
          formatButtonTextStyle: TextStyle(color: Colors.white),
          formatButtonShowsNext: false,
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: (date, events) {
          setState(() {
            _handleDatePicker(context);
            print(date.toIso8601String());
          });
        },
        builders: CalendarBuilders(
          selectedDayBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                date.day.toString(),
                style: TextStyle(color: Colors.white),
              )),
          todayDayBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                date.day.toString(),
                style: TextStyle(color: Colors.white),
              )),
        ),
        calendarController: _controller,
      ),
      Expanded(
          child: Container(
        child: BlocConsumer<NoteBloc, List<Note1>>(
            buildWhen: (List<Note1> previous, List<Note1> current) {
          return true;
        }, listenWhen: (List<Note1> previous, List<Note1> current) {
          return true;
        }, builder: (context, noteList) {
          return ValueListenableBuilder(
              valueListenable: Hive.box('notes').listenable(),
              builder: (context, Box notes, _) {
                print("List Built");
                return ListView.builder(
                  itemCount: noteList.length,
                  itemBuilder: (context, index) {
                    String _listDate =
                        new DateFormat.yMMMd().format(noteList[index].date);
                    String D = noteList[index].description;
                    String T = noteList[index].title;
                    if (noteList[index].date == _dateTime) {
                      D = noteList[index].description;
                      T = noteList[index].title;
                      _iconColor = Colors.green;
                      if (noteList[index].status == 1) {
                        _iconColor = Colors.blue;
                      }
                    } else {
                      D = '<= Press here to view';
                      T = '';
                      _iconColor = Colors.red;
                    }
                    String _print;
                    if (noteList[index].status == 1) {
                      _print = 'Complete';
                    } else {
                      _print = 'Incomplete';
                    }
                    return Card(
                      elevation: 6.0,
                      child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor: _iconColor,
                              child: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  onPressed: () {
                                    if (T == '') {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text(
                                                    "Item's Date is $_listDate"),
                                                content: SingleChildScrollView(
                                                    child: Column(children: <
                                                        Widget>[
                                                  Text(
                                                      'Press it if you wish to see all the items for the date $_listDate?'),
                                                  RaisedButton(
                                                      child:
                                                          Text("Select Date"),
                                                      onPressed: () {
                                                        setState(() {
                                                          _dateTime =
                                                              noteList[index]
                                                                  .date;
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      })
                                                ])));
                                          });
                                    }
                                  })),
                          subtitle: Text(D),
                          title: Text(T),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              if (T != '') {
                                BlocProvider.of<NoteBloc>(context).add(
                                  NoteEvent.delete(index),
                                );
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Successfully Deleted")));
                                notes.deleteAt(index);
                                print('Item Deleted');
                              }
                            },
                          ),
                          onLongPress: () {
                            setState(() {
                              if (T != '') {
                                if (index == null) {
                                  Titlecontroller.text = '';
                                  Desccontroller.text = '';
                                } else {
                                  Titlecontroller.text = noteList[index].title;
                                  Desccontroller.text =
                                      noteList[index].description;
                                  _task = 'Update';
                                }
                                addItemDialog();
                                BlocProvider.of<NoteBloc>(context).add(
                                  NoteEvent.delete(index),
                                );
                                notes.deleteAt(index);
                                print('Item Deleted');
                              }
                            });
                          },
                          onTap: () {
                            if (T != '') {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text('Change Status: $_print'),
                                        content: SingleChildScrollView(
                                            child: Column(children: <Widget>[
                                          DropdownButton<String>(
                                            items: _options.map(
                                                (String dropDownStringItem) {
                                              return DropdownMenuItem<String>(
                                                value: dropDownStringItem,
                                                child: Text(dropDownStringItem),
                                              );
                                            }).toList(),
                                            onChanged:
                                                (String newValueSelected) {
                                              setState(() {
                                                this._currentItemSelected =
                                                    newValueSelected;
                                              });
                                            },
                                            value: _currentItemSelected,
                                          ),
                                          RaisedButton(
                                            child: Text("Done"),
                                            onPressed: () {
                                              setState(() {
                                                if (_currentItemSelected ==
                                                    'Delete') {
                                                  BlocProvider.of<NoteBloc>(
                                                          context)
                                                      .add(
                                                    NoteEvent.delete(index),
                                                  );
                                                  Scaffold.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Successfully Deleted")));
                                                  notes.deleteAt(index);
                                                  print('Item Deleted');
                                                }
                                                if (_currentItemSelected ==
                                                    'Complete') {
                                                  noteList[index].status = 1;
                                                  notes.putAt(
                                                      index,
                                                      Note(
                                                          notes
                                                              .getAt(index)
                                                              .title,
                                                          notes
                                                              .getAt(index)
                                                              .description,
                                                          notes
                                                              .getAt(index)
                                                              .date,
                                                          0));
                                                }
                                                if (_currentItemSelected ==
                                                    'Incomplete') {
                                                  noteList[index].status = 0;
                                                  notes.putAt(
                                                      index,
                                                      Note(
                                                          notes
                                                              .getAt(index)
                                                              .title,
                                                          notes
                                                              .getAt(index)
                                                              .description,
                                                          notes
                                                              .getAt(index)
                                                              .date,
                                                          0));
                                                }
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                        ])));
                                  });
                            }
                          }),
                    );
                  },
                );
              });
        }, listener: (BuildContext context, noteList) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Added!')),
          );
        }),
      ))
    ]);
  }

  addItemDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('$_task Item'),
              content: SingleChildScrollView(
                  child: Column(children: <Widget>[
                TextField(
                  controller: Titlecontroller,
                  decoration: InputDecoration(
                      hintText: "Enter Agenda", labelText: "Enter a Task"),
                ),
                TextField(
                  controller: Desccontroller,
                  decoration: InputDecoration(
                      hintText: "Eg. To be done at 6pm",
                      labelText: "Enter the Description"),
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  child: Text("Select Date"),
                  onPressed: () {
                    _handleDatePicker(context);
                  },
                ),
                RaisedButton(
                  child: Text("Clear"),
                  onPressed: () {
                    setState(() {
                      Titlecontroller.text = '';
                      Desccontroller.text = '';
                    });
                  },
                ),
                RaisedButton(
                  child: Text("$_task"),
                  onPressed: () {
                    if (_dateTime == null) {
                      _handleDatePicker(context);
                    }
                    BlocProvider.of<NoteBloc>(context).add(
                      NoteEvent.add(
                        Note1(Titlecontroller.text, Desccontroller.text,
                            _dateTime, x),
                      ),
                    );
                    if (index == null) {
                      addItem(Note(Titlecontroller.text, Desccontroller.text,
                          _dateTime, x));
                      _showNotifications(
                          Titlecontroller.text, Desccontroller.text, _dateTime);
                      _showconfirmer(Titlecontroller.text, _dateTime);
                    } else {
                      final noteBox = Hive.box('notes');
                      addItem(Note(Titlecontroller.text, Desccontroller.text,
                          _dateTime, x));
                      _showNotifications(
                          Titlecontroller.text, Desccontroller.text, _dateTime);
                      _showconfirmer(Titlecontroller.text, _dateTime);
                      BlocProvider.of<NoteBloc>(context).add(
                        NoteEvent.delete(index),
                      );
                      noteBox.deleteAt(index);
                      print('Item Deleted');
                    }
                    Navigator.pop(context);

                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("$_task Successful")));
                  },
                )
              ])));
        });
  }
}