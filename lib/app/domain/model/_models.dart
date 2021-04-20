import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';

export 'UsuarioModel.dart';

abstract class ModelDb extends Equatable {
  final String tblname;
  final String fldIdName;

  ModelDb(this.tblname,this.fldIdName, this.pk);

  String get TableName => tblname;
  final String pk;

  Map<String, dynamic> toJson();

  DbCreate(Database db, {ConflictAlgorithm conflictPolicy: ConflictAlgorithm.ignore}) async {
    return await db.insert(TableName, this.toJson(), conflictAlgorithm: conflictPolicy);
  }

  Future<bool> DbExistById(Database db) async {
    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $tblname WHERE $fldIdName='$pk'"))>=1;
  }

  DbDeleteAll(Database db) async {
    return await db.rawDelete('DELETE FROM ${TableName}');
  }

  DbUpdate(Database db,String sql,List<dynamic> args) async {
    return await db.rawUpdate(sql,args);
  }

  Future<bool> DbDeleteWhere(Database db,String where,List<dynamic> whereArgs) async {
    return await db.delete(TableName,where: where,whereArgs: whereArgs)>=1;
  }
}