import 'dart:async';

import 'package:qrreaderapp/src/models/scan_model.dart';

class Validators {

  // StreamTransformer<List<ScanModel>, List<ScanModel>> primer argumento le dice que tipo de info ingresa
  // y luego que informacion sale
  final validarGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final geoScans = scans.where((s) => s.tipo == 'geo').toList();

      sink.add(geoScans);
    }
  );

  final validarHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final httpScans = scans.where((s) => s.tipo == 'http').toList();

      sink.add(httpScans);
    }
  );

}