import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:markets/src/elements/CircularLoadingWidget.dart';
import 'package:markets/src/models/route_argument.dart';
import 'package:markets/src/models/trip_model.dart';
import 'package:markets/src/viewmodels/history_cab_view_model.dart';
import 'package:stacked/stacked.dart';

class HistoryCab extends StatelessWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HistoryCab({Key key, this.parentScaffoldKey}) : super(key: key);



  NumberFormat _money = NumberFormat.currency(
    locale: 'es',
    symbol: 'COP',
    decimalDigits: 2,
  );




  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HistoryCabViewModels>.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => HistoryCabViewModels(),
        onModelReady: (model) {
          model.listenToTrips();
        },
        builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: SizedBox(),
            centerTitle: true,
            title: Text('Historial'),
          ),
          body: model.trips == null ? CircularLoadingWidget(height: 500,): SingleChildScrollView(
            child: Column(
              children:  model.trips.map((e) => _itemList(e, context)).toList(),
            ),
          )
        );
      }
    );
  }

  Widget _itemList(Trip trip, BuildContext context) {
    String _estado = '';
    Color _color = Colors.white;
    Color _colorText= Colors.black54;
    switch(trip.status.toString()){
      case  'Cancel':
      case 'CancelProfessional':
        _estado = 'Cancelado';
        _color = Colors.red;
        _colorText = Colors.white;
        break;
      case 'ExpireTime':
        _estado = 'Tiempo expirado';
        _color = Colors.red;
        _colorText = Colors.white;
        break;
      case 'Initial':
        _estado = 'Esperando el pago';
        _color = Colors.red;
        _colorText = Colors.white;
        break;
      case 'PaymentDriveFailed':
        _estado = 'Reintenta el pago';
        _color = Colors.red;
        _colorText = Colors.white;
        break;
      case 'PaymentDriveSuccess':
        _estado = 'Esperando el Conductor';
        _color = Colors.white;
        _colorText = Colors.black54;
        break;
      case 'Come':
        _estado = 'El Conductor llego a tu ubicación';
        _color = Colors.white;
        _colorText = Colors.black54;
        break;
      case 'InDrive':
        _estado = 'Vas en viaje';
        _color = Colors.white;
        _colorText = Colors.black54;
        break;
      case 'Arrive':
        _estado = 'Viaje finalizado';
        _color = Colors.white;
        _colorText = Colors.black54;
        break;
      default :
        _estado = 'Sin especificar';
        Color _color = Colors.white;
        Color _colorText= Colors.black54;
    }
    return Card(
      color: _color,
      elevation: 2,
      child: ListTile(
        onTap: (){
          Navigator.of(context).pushNamed('/TransactionCab', arguments: RouteArgument(id: trip.id));
        },
        title: Text('Estado: $_estado', style: TextStyle(color: _colorText),),
        subtitle: Text('Distancia ${trip.kilometres.toDouble().toStringAsFixed(1)} kilometros', style: TextStyle(color: _colorText) ),
      ),
    );
  }

}

