import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:markets/src/elements/ShoppingCartButtonWidget.dart';
import 'package:markets/src/models/route_argument.dart';
import 'package:markets/src/viewmodels/map_delivery_view_model.dart';
import 'package:stacked/stacked.dart';


// ignore: must_be_immutable
class MapDeliveryWidget extends StatefulWidget {
  @override
  _MapDeliveryWidgetState createState() => _MapDeliveryWidgetState();

  RouteArgument routeArgument;
  MapDeliveryWidget({Key key, this.routeArgument}) : super(key: key);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(3.7135652, -75.8697014),
    zoom: 5.75
  );

}

class _MapDeliveryWidgetState extends State<MapDeliveryWidget> {
  LatLng initialLocation;


  void _currentLocation(MapDeliveryModels model) async {
    final GoogleMapController controller =
    await model.controller.future;
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


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapDeliveryModels>.reactive(
        disposeViewModel: true,
        viewModelBuilder: () => MapDeliveryModels(),
        onModelReady: (model) {
          model.listenUser(widget.routeArgument.id);
          model.init();
        },
        builder: (context, model, child) {
        return Scaffold(
          appBar:  AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Rastrear repartidor',
              style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
            ),
            actions: <Widget>[
              new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
            ],
          ),
          body:  GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: model.markers,
            initialCameraPosition: MapDeliveryWidget._kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              model.controller.complete(controller);
              //Add second position to start position over

              Timer(Duration(seconds: 3), () => _currentLocation(model));

            },
          ),
        );
      }
    );
  }
}
