import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => scansBloc.countRows() > 0 ? _mostrarAlerta(context, currentIndex) : null
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigatorBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _crearBottomNavigatorBar() {
      return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Mapas')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5),
            title: Text('Webs')
          )
        ],
      );
  }

  Widget _callPage(int paginaActual) {
      
      switch (paginaActual) {
        case 0: return MapasPage();
        case 1: return DireccionesPage();

        default: return MapasPage();
      } 

  }


  _scanQR(BuildContext context) async {

    //  https://hanzelgodinez.com
    // geo:40.67946531257834,-73.93865004023439
    String futureString = '';

    try{
      futureString = await new QRCodeReader().scan();
    } catch(e){
      futureString = e.toString();
    }

    if (futureString != null){

      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.abrirScan(context, scan);
        });
      } else {
        utils.abrirScan(context, scan);
      }

    }

  }

  void _mostrarAlerta(BuildContext context, int paginaActual) {

    String tipoScan = '';

    if (paginaActual == 0) {
      tipoScan = 'geo';
    } else {
      tipoScan = 'http';
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Eliminar todos los registros'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Esta seguro que desea eliminar todos los registros?'),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Aceptar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
                scansBloc.borrarScanTodos(tipoScan);
              },
            ),
          ],
        );
      }
    );
  }
}