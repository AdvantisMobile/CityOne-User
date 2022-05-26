import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:markets/src/elements/CircularLoadingWidget.dart';
import 'package:markets/src/elements/ShoppingCartButtonWidget.dart';
import 'package:markets/src/models/route_argument.dart';
import 'package:markets/src/models/vehicle.dart';
import 'package:markets/src/viewmodels/select_drive_view_model.dart';
import 'package:stacked/stacked.dart';

class SelectTypeDrive extends StatelessWidget {
  NumberFormat _money = NumberFormat.currency(
    locale: 'es',
    symbol: 'COP',
    decimalDigits: 2,
  );
  
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectedDriveViewModels>.reactive(
        disposeViewModel: true,
        viewModelBuilder: () => SelectedDriveViewModels(),
        onModelReady: (model) {
          model.listenForVehicles();
        },
        builder: (context, model, child) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Seleccione un vehiculo',
                style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
              ),
              actions: <Widget>[
                new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
              ],
            ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:  model.vehicles != null && model.vehicles.length > 0 ? SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                primary: false,
                children: model.vehicles.map((e) => _selectItem(e, context),).toList()
              ),
            ): CircularLoadingWidget(height: 500,),
          )
        );
      }
    );
  }

  Widget _selectItem(Vehicle vehicle, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: ListTile(
          selected: true,
          onTap: (){
            Navigator.of(context).pushReplacementNamed('/Redeban', arguments: RouteArgument(id: vehicle.price.toString()));
          },
          title: Text(vehicle.name, style: TextStyle(color: Colors.black54, fontSize: 18.0, fontWeight: FontWeight.bold),),
          subtitle: Text("Basico +  ${_money.format(vehicle.price)}", style: TextStyle(color: Colors.black54, fontSize: 16.0, fontWeight: FontWeight.bold),),
          leading: CachedNetworkImage(
            height: 60,
            width: 60,
            fit: BoxFit.cover,
            imageUrl: vehicle.image.thumb,
            placeholder: (context, url) => Image.asset(
              'assets/img/loading.gif',
              fit: BoxFit.cover,
              height: 60,
              width: 60,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  } 
}
