import 'dart:async';
import 'dart:io';
import 'package:apnapp/app/common/logger.dart';
import 'package:apnapp/app/domain/model/_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {

  factory AppDatabase() => _instanceDatabase;
  static final AppDatabase _instanceDatabase = AppDatabase._internal();

  //private internal constructor to make it singleton
  AppDatabase._internal();

  Database _database;

//  static AppDatabase get() {
//    return _instanceDatabase;
//  }

  bool didInit = false;

  /// Use this method to access the database which will provide you future of [Database],
  /// because initialization of the database (it has to go through the method channel)
  Future<Database> getDb() async {
    if (!didInit) await _init();
    return _database;
  }

  void close() async {
    await _database.close();
    didInit=false;
    logger.i("BD.closed");
  }

  Future _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "app_apllemernav1.db");
    logger.i('DB.Init. Path:${path}');

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          //await _createChangeState(db);

        }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
//          await db.execute("DROP TABLE ${Tasks.tblTask}");
          ;
        });

    didInit = true;
  }

  // Future _createChangeState(Database db) {
  //   return db.transaction((Transaction txn) async {
  //     txn.execute("CREATE TABLE ${ChangeStateModel.tbl} ("
  //         "${ChangeStateModel.dbId} TEXT PRIMARY KEY,"
  //         "${ChangeStateModel.dbMatricula} TEXT,"
  //         "${ChangeStateModel.dbTimestamp} TEXT,"
  //         "${ChangeStateModel.dbStateTx} TEXT,"
  //         "${ChangeStateModel.dbSpeed} INTEGER,"
  //         "${ChangeStateModel.dbBearing} INTEGER,"
  //         "${ChangeStateModel.dbGpsPoint} TEXT);");
  //   });
  // }


  //ACCIONTS ON MODELS
  createModel(ModelDb model) async {
    return await model.DbCreate(await getDb());
  }

  deleteModel(ModelDb model) async {
    return await model.DbCreate(await getDb());
  }

  deleteModelWhere(ModelDb model) async {
    return await model.DbCreate(await getDb());
  }

  Future<bool> deleteWhere(ModelDb model,String where,List<dynamic> whereArgs) async {
    return await model.DbDeleteWhere(await getDb(),where,whereArgs);
  }

}