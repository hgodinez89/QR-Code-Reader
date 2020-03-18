import 'dart:io';

import 'package:path/path.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
// Sirve para exponer a los archivos que utilicen el DBProvider este archivo
export 'package:path_provider/path_provider.dart';

class DBProvider{
  // Se implementa mediante el patron singleton, es decir solo una instancia 
  // global de la clase.

  static Database _database;
  // Se crea una instancia del widget, tambien se puede DBProvider.private()
  static final DBProvider db = DBProvider._(); 

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  get list => null;

  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Scans ('
          '  id INTEGER PRIMARY KEY,'
          '  tipo TEXT,'
          '  valor TEXT'
          ')'
        );
      }
    );

  }

  // Crear registros forma 1
  nuevoScanRaw(ScanModel nuevoScan) async {

    final db = await database;

    final res = await db.rawInsert(
      "INSERT Into Scans (id, tipo, valor) "
      "VALUES (${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}')"
    );

    return res;

  }

  // Crear registros forma 2 (Mejor)
  nuevoScan(ScanModel nuevoScan) async {

    final db = await database;

    final res = await db.insert('Scans', nuevoScan.toJson());

    return res;
  }  

  // Select - especifico por un tipo (Mejor)
  Future<ScanModel> getScanId(int id) async {

    final db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;

  }

  // Select sin where
  Future<List<ScanModel>> getAllScans() async {

    final db = await database;

    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty 
                              ? res.map((c) => ScanModel.fromJson(c)).toList()
                              : [];

    return list;

  }

  // Select especifico por un tipo
  Future<List<ScanModel>> getScansByType(String type) async {

    final db = await database;

    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo = '$type'");

    List<ScanModel> list = res.isNotEmpty
                              ? res.map((c) => ScanModel.fromJson(c)).toList()
                              : [];

    return list;
    
  }

  Future<int> updateScan(ScanModel nuevoScan) async {

    final db = await database;

    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id]);

    return res;

  }

  Future<int> deleteScan(int id) async {

    final db = await database;

    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
    
  }

  Future<int> deleteAllScan(String type) async {

    final db = await database;

    final res = await db.delete('Scans', where: 'tipo = ?', whereArgs: [type]);
    // final res = await db.rawDelete('DELETE FROM Scans');

    return res;
   
  }

}