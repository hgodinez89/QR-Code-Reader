import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class DireccionesPage extends StatelessWidget {
  final scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.obtenerScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final scans = snapshot.data;

        if (scans.length == 0) {
          return Center(
            child: Text('No hay información'),
          );
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: _DeleteFlag('centerLeft'),
            secondaryBackground: _DeleteFlag('centerRight'),
            onDismissed: (direction) => scansBloc.borrarScan(scans[i].id),
            child: ListTile(
              leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor,),
              title: Text(scans[i].valor),
              subtitle: Text('ID: ${scans[i].id}'),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              onTap: () => utils.abrirScan(context, scans[i]),
            ),
          )
        );
      },
    );
  }
}

class _DeleteFlag extends StatelessWidget {
    const _DeleteFlag(this._alignment);

    final _alignment;

    @override
    Widget build(BuildContext context) {
      return Container(
        color: Colors.red,
        alignment:  _alignment == 'centerRight' ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        child: Text('Eliminar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),),
      );
    }
}