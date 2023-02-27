import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int? selectedId;
  final textcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Container(
            padding: EdgeInsets.only(bottom: 20),
            margin: EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Enter a Note..",
                hintStyle:
                    TextStyle(color: Colors.black, fontSize: 18, height: 2),
              ),
              controller: textcontroller,
            ),
          ),
        ),
        body: Center(
          child: FutureBuilder<List<Note>>(
              future: DatabaseHelper.instance.getNotes(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text("Loading..."));
                }
                return snapshot.data!.isEmpty
                    ? Center(child: Text("No Note List.."))
                    : ListView(
                        children: snapshot.data!.map((note) {
                          return Center(
                            child: Card(
                              margin: EdgeInsets.only(left: 10, right: 13, bottom: 17, top: 10),
                              color: selectedId == note.id
                                ? Colors.blueAccent
                              : Colors.white,
                              child: ListTile(
                                title: Text(note.name),
                                onTap: () {
                                  setState(() {
                                    if(selectedId == null){
                                      textcontroller.text = note.name;
                                      selectedId = note.id;
                                    }
                                    else{
                                      textcontroller.text = '';
                                      selectedId = null;
                                    }
                                  });
                                },
                                onLongPress: () {
                                  setState(() {
                                    DatabaseHelper.instance.remove(note.id!);
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            selectedId != null
                ? DatabaseHelper.instance.update(
                    Note(id: selectedId, name: textcontroller.text),
                  )
                : await DatabaseHelper.instance.add(
                    Note(name: textcontroller.text),
                  );
            setState(() {
              textcontroller.clear();
            });
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }
}

class Note {
  final int? id;
  final String name;

  Note({this.id, required this.name});

  factory Note.fromMap(Map<String, dynamic> json) => Note(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._priveteConstructor();
  static final DatabaseHelper instance = DatabaseHelper._priveteConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes(
          id INTEGER PRIMARY KEY,
          name TEXT
      )
      ''');
  }

  Future<List<Note>> getNotes() async {
    Database db = await instance.database;
    var notes = await db.query('notes', orderBy: 'name');
    List<Note> noteList =
        notes.isNotEmpty ? notes.map((c) => Note.fromMap(c)).toList() : [];
    return noteList;
  }

  Future<int> add(Note notes) async {
    Database db = await instance.database;
    return await db.insert('notes', notes.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Note notes) async {
    Database db = await instance.database;
    return await db
        .update('notes', notes.toMap(), where: "id = ?", whereArgs: [notes.id]);
  }
}
