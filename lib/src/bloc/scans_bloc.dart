import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/providers/db_provide.dart';

// Mediante el with se heredan los metodos o atributos de la clase Validator
// Esto es conocido como mixins
class ScansBloc with Validators {
  
  // Instancia privada a la clase de tipo Singlenton con constructor internal privado
  // esto solo permite una unica instancia en toda la app
  static final ScansBloc _singleton = ScansBloc._internal();
  int _countLista;

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal () {
    // Obtener Scans de la base de datos
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  // Estos Stream estan haciendo uso de los Validator de la clase Validator, de la cual se realiza un mixin
  Stream<List<ScanModel>> get scansStream     => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);

  dispose() {
    _scansController?.close();
  }

  // Esto metodos por lo general se crean en un archivo separado llamado events
  int countRows() {
    return _countLista;
  }

  agregarScan(ScanModel scan) async {
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  obtenerScans() async {
    List<ScanModel> list = await DBProvider.db.getAllScans();
    _countLista = list.length;
    _scansController.sink.add(list);
  }

  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTodos(String type) async {
    await DBProvider.db.deleteAllScan(type);
    _countLista = 0;
    // Seria lo mismo que obtenerScans(); pero como sabemos que no va a quedar nadas entonces podemos 
    // hacer lo siguiente para no consultar en la BD
    _scansController.sink.add([]);
  }

}