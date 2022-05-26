import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart' as geoco;
import 'package:location/location.dart';
import 'package:markets/src/models/trip_model.dart';
import 'package:markets/src/models/vehicle.dart';
import 'package:markets/src/viewmodels/home_cab_view_model.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:stacked/stacked.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:intl/intl.dart';

class HomeCab extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeCab({Key key, this.parentScaffoldKey}) : super(key: key);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(3.7135652, -75.8697014),
    zoom: 5.75,
  );

  static final geocoding = new geoco.GoogleMapsGeocoding(
      apiKey: "AIzaSyCPWW4q6F5GW49NYrYQqdvnnoNEy-U_YKU");

  @override
  _HomeCabState createState() => _HomeCabState();
}

class _HomeCabState extends State<HomeCab> {
  AddressesTrip _addressFrom;
  AddressesTrip _addressTo;

  LatLng initialLocation;

  NumberFormat _money = NumberFormat.currency(
    locale: 'es',
    symbol: 'COP',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeCabViewModels>.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => HomeCabViewModels(),
        onModelReady: (model) {
          model.listenToTrips();
          model.listenForVehicles();
        },
        builder: (context, model, child) => Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
                leading: new FloatingActionButton(
                  backgroundColor: Colors.white,
                  child:
                      new Icon(Icons.menu, color: Theme.of(context).hintColor),
                  onPressed: () =>
                      widget.parentScaffoldKey.currentState.openDrawer(),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Viaja'),
                )),
            bottomSheet: SolidBottomSheet(
              elevation: 1.0,
              maxHeight: 150.0,
              controller: model.controllerSliding,
              draggableBody: false,
              minHeight: 0.00,
              toggleVisibilityOnTap: true,
              headerBar: Container(
                color: Theme.of(context).primaryColor,
                height: 50,
                child: Center(
                  child: Text(
                    "Viaje",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black54),
                  ),
                ),
              ),
              body: Container(
                color: Colors.white,
                child: Stack(
                    children: model.drivers != null
                        ? <Widget>[
                            model.drivers.length > 0 ? Positioned(
                                top: 0.0,
                                right: 10.0,
                                left: 10.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 80,
                                      width: double.infinity,
                                      child: ListView(
                                        primary: true,
                                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        children: model.vehicles.map((element) => _vehicleWidget(model, element, context)).toList()
                                      ),
                                    ),

                                  ],
                                )): Text('No hay conductores')
                          ]
                        : [Text('Ingresa las direcciones...')]),
              ),
            ),
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: HomeCab._kGooglePlex,
                  markers: model.markers,
                  polylines: model.polylines,
                  onMapCreated: (GoogleMapController controller) {
                    model.googleMapController.complete(controller);

                    Timer(Duration(seconds: 1), () => _currentLocation(model));
                  },
                ),
                Positioned(
                  top: 90.0,
                  right: 15.0,
                  left: 15.0,
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(1.0, 5.0),
                                  blurRadius: 10,
                                  spreadRadius: 3)
                            ],
                          ),
                          child: initialLocation != null
                              ? _addressFromWidget(model)
                              : SizedBox()),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(1.0, 5.0),
                                  blurRadius: 10,
                                  spreadRadius: 3)
                            ],
                          ),
                          child: initialLocation != null
                              ? _addressToWidget(model)
                              : SizedBox()),
                    ],
                  ),
                ),
              ],
            )));
  }

  void _currentLocation(HomeCabViewModels model) async {
    final GoogleMapController controller =
        await model.googleMapController.future;
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

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
      ),
    ));
  }

  Widget _addressFromWidget(HomeCabViewModels model) {
    return SearchMapPlaceWidget(
      apiKey: "AIzaSyCPWW4q6F5GW49NYrYQqdvnnoNEy-U_YKU",
      language: 'es',
      placeholder: '¿Donde te recogemos?',
      placeType: PlaceType.address,
      location: initialLocation,
      radius: 30000,
      onSelected: (Place place) async {
        geoco.GeocodingResponse response =
            await HomeCab.geocoding.searchByAddress(place.description);
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

  Widget _addressToWidget(HomeCabViewModels model) {
    return SearchMapPlaceWidget(
      apiKey: "AIzaSyCPWW4q6F5GW49NYrYQqdvnnoNEy-U_YKU",
      language: 'es',
      placeholder: '¿A donde te llevamos?',
      placeType: PlaceType.address,
      location: initialLocation,
      radius: 30000,
      onSelected: (Place place) async {
        geoco.GeocodingResponse response =
            await HomeCab.geocoding.searchByAddress(place.description);
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

  void _verifyAddress(HomeCabViewModels model) {
    if (_addressTo != null && _addressFrom != null) {
      // model.setTrip(_addressFrom, _addressTo).then((value) => showAsBottomSheet());
      model.setTrip(_addressFrom, _addressTo);
    }
  }

  Widget _vehicleWidget(HomeCabViewModels model, Vehicle vehicle, BuildContext context) {
    var value = model.drivers.firstWhere((element) => element.typeId == vehicle.id, orElse:()=> null);
    return Opacity(
      opacity: value != null ? 1 : 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          onTap: (){
            if(value != null){
              model.createdTrip(value, vehicle, _addressFrom, _addressTo, context);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FadeInImage(
                  height: 40,
                  width: 40,
                  placeholder: AssetImage('assets/img/loading.gif'),
                  image: NetworkImage(vehicle.image.thumb),

              ),
              Center(
                child: Text(vehicle.name, style: TextStyle(color: Colors.black54, fontSize: 12)),
              ),
              SizedBox(height: 5.0,),
              Center(
                  child: Text(
                    "${_money.format(model.calculateRate(vehicle.price.toDouble()))}",
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  )),
            ],
          ),
        ),
      ),
    );
  } 


}
