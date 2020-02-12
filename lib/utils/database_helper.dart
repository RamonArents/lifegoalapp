// import required packages
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqllitetest/models/lifegoal.dart';

/*
this class creates the database, tables and CRUD functionality for the tables. It also creates a list to display in the view.
*/
class DatabaseHelper {
  //initiaze database variables
  static DatabaseHelper _databaseHelper;
  static Database _database;
  //declare table name and column names
  String goalTable = 'goal_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';
  String colReached = 'reached';
  // create an instance of the database
  DatabaseHelper._createInstance();
  /*
  factory to create the database
  @return _databasehelper
  */
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }
  /*
  getter to get the created database
  @return database
  */
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  /*
  function to initialize the database 
  @return database
  */
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'lifegoals.db';

    var lifegoalsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);

    return lifegoalsDatabase;
  }

  /*
  function to create the table of the database
  @return void
  */
  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $goalTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,'
        '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT, $colReached INTEGER)');
  }

  /*
  function to select data from the table
  @return result (the query result)
  */
  getLifegoalMapList() async {
    Database db = await this.database;

    var result =
        await db.query(goalTable, orderBy: '$colPriority ASC, $colReached ASC');
    return result;
  }

  /*
  function to insert data
  @param LifeGoal (the lifeGoal object)
  @return result (success or failure)
  */
  Future<int> insertLifegoal(LifeGoal lifegoal) async {
    Database db = await this.database;
    var result = await db.insert(goalTable, lifegoal.toMap());
    return result;
  }

  /*
  function to update data
  @param LifeGoal (the lifegoal object)
  @return result (success or failure)
  */
  Future<int> updateLifegoal(LifeGoal lifegoal) async {
    Database db = await this.database;
    var result = await db.update(goalTable, lifegoal.toMap(),
        where: '$colId = ?', whereArgs: [lifegoal.id]);
    return result;
  }

  /*
  function to delete data
  @param id (the id of the lifegoal object)
  @return result (success or failure)
  */
  Future<int> deleteLifegoal(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $goalTable WHERE $colId = $id');
    return result;
  }

  /*
  function to count the records in the table
  @return result (the query result)
  */
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $goalTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  /*
  function to create the list with the data
  @return lifegoalList (the list with data)
  */
  Future<List<LifeGoal>> getLifegoalList() async {
    var lifegoalMapList = await getLifegoalMapList();
    int count = lifegoalMapList.length;

    List<LifeGoal> lifegoalList = List<LifeGoal>();

    for (int i = 0; i < count; i++) {
      lifegoalList.add(LifeGoal.fromMapObject(lifegoalMapList[i]));
    }
    return lifegoalList;
  }
}
