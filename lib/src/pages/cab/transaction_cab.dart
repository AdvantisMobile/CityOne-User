import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:markets/src/elements/CircularLoadingWidget.dart';
import 'package:markets/src/models/route_argument.dart';
import 'package:markets/src/viewmodels/transaction_view_model.dart';
import 'package:stacked/stacked.dart';


// ignore: must_be_immutable
class TransactionCab extends StatelessWidget {
  RouteArgument routeArgument;
  TransactionCab({Key key, this.routeArgument}) : super(key: key);

  NumberFormat _money = NumberFormat.currency(
    locale: 'es',
    symbol: 'COP',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TransactionViewModels>.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => TransactionViewModels(),
        onModelReady: (model) {
          model.listenToTrip(routeArgument.id);
        },
      builder: (context, model, child) {
        return Scaffold(
          body: model.trip == null?  CircularLoadingWidget(height: 500,) : Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SafeArea(
                      child: model.trip.type == 'uber' ? Image.asset('assets/img/taxi.png', height: 200,) : Image.asset('assets/img/delivery.png', height: 200,)
                  ),
//                  SizedBox(height: 20.0,),
//                  Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: [
//                      Text('Conductor:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),),
//                      SizedBox(width: 5,),
//                      Text('${model.trip.user.name}', style: TextStyle(fontSize: 18, color: Colors.black54),),
//                    ],
//                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Precio:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),),
                      SizedBox(width: 5,),
                      Text('${_money.format(model.trip.total)}', style: TextStyle(fontSize: 18, color: Colors.black54),),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Kilometros:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),),
                      SizedBox(width: 5,),
                      Text(model.trip.kilometres.toStringAsFixed(2), style: TextStyle(fontSize: 18, color: Colors.black54),),
                    ],
                  ),
                  ...StatusTripWidget(model, context),

                ],
              ),
            ),
          ),
        );
      }
    );
  }

  List<Widget> StatusTripWidget(TransactionViewModels model, BuildContext context) {
    switch(model.trip.status){
      case 'Initial':
        return [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: LinearProgressIndicator(),
          ),
          SizedBox(height: 10,),
          Text('Realiza el pago', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),
          SizedBox(height: 10,),
          RaisedButton(
              color: Colors.blue,
              child: Text('PAGAR', style: TextStyle(color: Colors.white),),
              onPressed:(){
                Navigator.of(context).pushNamed('/PaymentTrip', arguments: RouteArgument(
                    id: model.trip.id,
                    param: model.trip.total.toInt().toString()
                ));
              }
              )
        ];
      case 'PaymentDriveFailed':
        return [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: LinearProgressIndicator(),
          ),
          SizedBox(height: 10,),
          Text('Pago fallido', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),),
          SizedBox(height: 10,),
          Text('Reintenta el pago', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),
          SizedBox(height: 10,),
          RaisedButton(
              color: Colors.blue,
              child: Text('PAGAR', style: TextStyle(color: Colors.white),),
              onPressed:(){
                 Navigator.of(context).pushNamed('/PaymentTrip', arguments: RouteArgument(
                   id: model.trip.id,
                   param: model.trip.total
                 ));
              }
              )
        ];
      case 'CancelProfessional':
      case 'Cancel':
        return [
          Text('El servicio fue cancelado', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),),
        ];
      case 'Come':
        return [
          Text('Tu conductor a llegado', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),
        ];
      case 'InDrive':
        return [

          Text(model.trip.type == 'uber' ?'vas en camino': 'Tu paquete esta en camino', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),)
        ];
      case 'Arrive':
        return [
          Text(model.trip.type == 'uber' ? 'Has llegado a tu destino': 'Tu producto ha llegado', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),
        ];
      case 'ExpireTime':
        return [
          Text( 'Este servicio ha expirado', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),
        ];
      case 'PaymentDriveSuccess':
        return [
          Text( 'Pago exitoso', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),
          SizedBox(height: 10,),
          Text( 'Espera al conductor', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),
        ];
    }
  }
}
