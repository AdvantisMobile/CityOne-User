import 'package:google_maps_webservice/geocoding.dart' as geoco;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:markets/src/elements/CircularLoadingWidget.dart';
import 'package:markets/src/models/trip_model.dart';
import 'package:markets/src/viewmodels/home_shipment_view_model.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:stacked/stacked.dart';



class HomeShipment extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeShipment({Key key, this.parentScaffoldKey}) : super(key: key);

  static final geocoding = new geoco.GoogleMapsGeocoding(
      apiKey: "AIzaSyCPWW4q6F5GW49NYrYQqdvnnoNEy-U_YKU");

  @override
  _HomeShipmentState createState() => _HomeShipmentState();
}

class _HomeShipmentState extends State<HomeShipment> {
  AddressesTrip _addressFrom;
  AddressesTrip _addressTo;

  LatLng initialLocation;

  NumberFormat _money = NumberFormat.currency(
    locale: 'es',
    symbol: 'COP',
    decimalDigits: 2,
  );

  @override
  void initState() {
    _currentLocation();
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeShipmentViewModels>.reactive(
        disposeViewModel: true,
        viewModelBuilder: () => HomeShipmentViewModels(),
        onModelReady: (model) {
          model.initScaffold();
          model.listenToTrips();
          model.listenForVehicles();
        },
        builder: (context, model, child) {
        return Scaffold(
          key: model.scaffoldKey,
          backgroundColor: Colors.white,
          body: initialLocation == null && model.vehicles != null ? CircularLoadingWidget(height: 500,) : Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Form(
                key: model.tripFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                              child: Text('Realiza un envio',
                                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 23),
                              ),
                      )
                    ),
                    SizedBox(height: 20.0,),
                    _addressFromWidget(model),
                    SizedBox(height: 10.0,),
                    _addressToWidget(model),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 10)],
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => model.trip.product = input,
                          validator: (input) => input.isEmpty ? 'Este campo es reqerido' : null,
                          decoration: InputDecoration(

                            labelText: '¿Que envias?',
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'caja',
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.markunread_mailbox, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 10)],
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onSaved: (input) => model.trip.amountProduct = double.parse(input),
                          validator: (input) => input.isEmpty ? 'Este campo es reqerido' : null,
                          decoration: InputDecoration(
                            labelText: 'Valor del paquete',
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'precio para el seguro',
                            helperText: 'Este campo es para el seguro del paquete',
                            helperStyle: TextStyle(color: Colors.black54,),
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.monetization_on, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 10)],
                        ),
                        child: TextFormField(
                          maxLines: 3,
                          minLines: 2,
                          keyboardType: TextInputType.multiline,
                          onSaved: (input) => model.trip.description = input,
                          validator: (input) => input.isEmpty ? 'Este es requerido' : null,
                          decoration: InputDecoration(
                            labelText: 'Descripción',
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'descripción',
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.description, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButton(
                        value: model.vehicleId,
                        isDense: true,
                        hint: Text('Seleccione uno', style: TextStyle(color: Colors.black54),),
                        isExpanded: true,
                          items: model.vehicles.map((e) {
                            return DropdownMenuItem(
                                child: Center(child: Text('${e.name} - ${_money.format(e.price)} por klm', style: TextStyle(fontSize: 14, color: Colors.black54),)),
                                value: e.id,
                            );
                          }).toList(),
                          onChanged: (value){
                            model.changeVehicle(value);
                          },
                      ),
                    ),

                    SizedBox(height: 10,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Text('Total:', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),),
                          SizedBox(width: 10,),
                          Text(model.trip.total == null ? '': '${_money.format(model.trip.total)}', style: TextStyle(color: Colors.black87, fontSize: 18),),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Text('Kilometros:', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),),
                          SizedBox(width: 10,),
                          Text(model.trip.kilometres == null ? '': '${model.trip.kilometres.toStringAsFixed(2)}', style: TextStyle(color: Colors.black87, fontSize: 18),),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    model.trip.total == null ?  MaterialButton(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      color: Colors.blue,
                      onPressed: (){
                        model.validateTrip(_addressFrom, _addressTo);
                      },
                      textColor: Colors.white70,
                      child: Text('Validar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ) : MaterialButton(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      color: Colors.blue,
                      onPressed: (){
                        model.createdTrip(context);
                      },
                      textColor: Colors.white70,
                      child: Text('Continuar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ),

                  ],
                ),
              ),
            ),
          ),

        );
      }
    );
  }
  Widget _addressFromWidget(HomeShipmentViewModels model) {
    return SearchMapPlaceWidget(
      apiKey: "AIzaSyCPWW4q6F5GW49NYrYQqdvnnoNEy-U_YKU",
      language: 'es',
      placeholder: '¿Donde lo buscamos?',
      placeType: PlaceType.address,
      location: initialLocation,
      radius: 30000,
      onSelected: (Place place) async {
        geoco.GeocodingResponse response =
        await HomeShipment.geocoding.searchByAddress(place.description);
        print(response.results[0].geometry.location.lat);
        if (response.results.length > 0) {
          setState(() {
            _addressFrom = AddressesTrip(
              address: place.description,
              lat: response.results[0].geometry.location.lat,
              lng: response.results[0].geometry.location.lng,
            );
          });
          _verifyAddress(model);
        }
      },
    );
  }

  Widget _addressToWidget(HomeShipmentViewModels model) {
    return SearchMapPlaceWidget(
      apiKey: "AIzaSyCPWW4q6F5GW49NYrYQqdvnnoNEy-U_YKU",
      language: 'es',
      placeholder: '¿Donde lo dejamos?',
      placeType: PlaceType.address,
      location: initialLocation,
      radius: 30000,
      onSelected: (Place place) async {
        geoco.GeocodingResponse response =
        await HomeShipment.geocoding.searchByAddress(place.description);
        print(response.results[0].geometry.location.lat);
        if (response.results.length > 0) {
          setState(() {
            _addressTo = AddressesTrip(
              address: place.description,
              lat: response.results[0].geometry.location.lat,
              lng: response.results[0].geometry.location.lng,
            );
          });
          _verifyAddress(model);
        }
      },
    );
  }

  void _verifyAddress(HomeShipmentViewModels model) {
    if (_addressTo != null && _addressFrom != null) {
      // model.setTrip(_addressFrom, _addressTo).then((value) => showAsBottomSheet());
      model.setTrip(_addressFrom, _addressTo);
    }
  }

  void _currentLocation() async {

    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
      setState(() {
        initialLocation =
            LatLng(currentLocation.latitude, currentLocation.longitude);
      });
    } on Exception {
      currentLocation = null;
    }

  }

}
