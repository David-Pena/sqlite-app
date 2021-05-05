import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'person.dart';
import 'validation.dart';

class DB {
  static Database _db;
  static const String DOCUMENT = 'document';
  static const String NAME = 'name';
  static const String ADDRESS = 'address';
  static const String PLACE = 'place';
  static const String CONTAGIONDATE = 'date';
  static const String TABLE = 'Person';
  static const String DB_NAME = 'person.db';
  Validation v = new Validation();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  showCustomDialog(BuildContext context, String title, String content, int type,
      bool isNotOne) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 230,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    type == 1
                        ? Icons.done_rounded
                        : Icons.error_outline_rounded,
                    size: 50,
                    color: type == 1 ? Colors.green : Colors.red,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    child: Text(
                      content,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: () {
                        if (isNotOne) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(fontSize: 15, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($DOCUMENT TEXT PRIMARY KEY, $NAME TEXT, $ADDRESS TEXT, $PLACE TEXT, $CONTAGIONDATE DATE)");
  }

  Future<bool> save(Person person, BuildContext context) async {
    var dbClient = await db;
    bool val = false;

    await dbClient.transaction((txn) async {
      var query =
          "INSERT INTO $TABLE ($DOCUMENT, $NAME, $ADDRESS, $PLACE, $CONTAGIONDATE) VALUES ('" +
              person.document +
              "', '" +
              person.name +
              "', '" +
              person.address +
              "', '" +
              person.place +
              "', '" +
              person.date +
              "')";
      try {
        await txn.rawInsert(query);
        showCustomDialog(
            context, "Success", "The person was registered successfully", 1, true);
        val = true;
      } catch (e) {
        if (e.isUniqueConstraintError()) {
          showCustomDialog(context, "Warning",
              "Document number is in use, please change it", 2, false);
          val = false;
        } else {
          showCustomDialog(
              context, "Error", "There was an error registering the person", 2, false);
          val = false;
        }
      }
    });
    return val;
  }

  Future<List<Person>> getData() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE, columns: [DOCUMENT, NAME, ADDRESS, PLACE, CONTAGIONDATE]);
    List<Person> data = [];
    if (maps.length > 0) {
      for (var i = 0; i < maps.length; i++) {
        data.add(Person.fromMap(maps[i]));
      }
    }
    return data;
  }

  Future<int> delete(String document, BuildContext context) async {
    var dbClient = await db;

    await dbClient.transaction((txn) async {
      var query = "DELETE FROM $TABLE WHERE $DOCUMENT = '" + document + "'";
      try {
        return await txn.rawDelete(query);
      } catch (e) {
        showCustomDialog(
            context, "Error", "There was an error deleting the person", 2, false);
      }
    });
    return 0;
  }

  Future<bool> update(Person person, BuildContext context) async {
    var dbClient = await db;
    var val = true;
    try {
      await dbClient.update(TABLE, person.toMap(),
          where: '$DOCUMENT = ?', whereArgs: [person.document]);
      showCustomDialog(context, "Success",
          "The person's information was updated successfully", 1, true);
    } catch (e) {
      showCustomDialog(context, "Error",
          "There was an error updating the person's information", 2, false);
    }
    return val;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
