
import 'dart:async';
import 'dart:ui';
import 'dart:math' show cos, sqrt, asin;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/dom.dart';
import 'package:markets/src/models/route_argument.dart';
import 'package:markets/src/models/trip_model.dart';
import 'package:markets/src/models/user.dart';
import 'package:markets/src/models/vehicle.dart';
import 'package:markets/src/repository/vehicles_repository.dart';
import 'package:markets/src/services/firestore_service.dart';
import 'package:markets/src/viewmodels/base_model.dart';
import 'package:geodesy/geodesy.dart' as GEO;
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:geoflutterfire/geoflutterfire.dart' as geofire;

import '../../locator.dart';

class HomeCabViewModels extends BaseModel {
  final firestoreService _firestoreService = locator<firestoreService>();
  final geof = geofire.Geoflutterfire();


  List<User> _drivers;
  List<User> get drivers => _drivers;

  //GEO.LatLng midPoint;
  // this set will hold my markers
  Set<Marker> _markers = {};

  Set<Marker> get markers => _markers;

  // this will hold the generated polylines
  Set<Polyline> polylines = {};

  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];

  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  final String googleAPIKey = "AIzaSyCPWW4q6F5GW49NYrYQqdvnnoNEy-U_YKU";
  PolylinePoints polylinePoints = PolylinePoints();
  CameraPosition initialLocation;

  double _money;

  double get money => _money;

  Completer<GoogleMapController> googleMapController = Completer();
  SolidController controllerSliding = SolidController();

  List<Vehicle> vehicles = <Vehicle>[];

  List<Trip> _trips;

  List<Trip> get trips => _trips;


  Future<void> listenForVehicles() async {
    final Stream<Vehicle> stream = await getVehicles();
    stream.listen((Vehicle _vehicle) {
      if (_vehicle.role == 'uber') {
        vehicles.add(_vehicle);
      }
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }



  void listenToDrivers(AddressesTrip addressFrom) {
    setBusy(true);
    geofire.GeoFirePoint fromLocation = geof.point(latitude: addressFrom.lat, longitude: addressFrom.lng);
    _firestoreService.listenToUsersLocationRealTime('uber', fromLocation ).listen((tripData) {
      List<User> updatedTrips = tripData;
      if (updatedTrips != null && updatedTrips.length > 0) {
        _drivers = updatedTrips;
        notifyListeners();
      }
      setBusy(false);
    });
  }


  void listenToTrips() {
    setBusy(true);
    if( currentUser.apiToken != null ){
      _firestoreService.listenToTripsRealTime(currentUser.id, 'uber').listen((tripData) {
        List<Trip> updatedTrips = tripData;
        if (updatedTrips != null && updatedTrips.length > 0) {
          _trips = updatedTrips;
          notifyListeners();
        }
        setBusy(false);
      });
    }else{
      _trips = [];
      setBusy(false);

    }
  }

  getCenterLocation(LatLng addressFrom, LatLng addressTo)  {
    return  GEO.Geodesy().midPointBetweenTwoGeoPoints(
        GEO.LatLng(addressFrom.latitude, addressFrom.longitude),
        GEO.LatLng(addressTo.latitude, addressTo.longitude)
    );
  }


  setPolylines(LatLng addressFrom, LatLng addressTo) async{
    setBusy(true);

    PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(addressFrom.latitude, addressFrom.longitude),
      PointLatLng(addressTo.latitude, addressTo.longitude),
      travelMode: TravelMode.driving,
    );


    if (result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });


      notifyListeners();
    }

    Polyline polyline = Polyline(
        polylineId: PolylineId("poly"),
        color: Color.fromARGB(255, 40, 122, 198),
        points: polylineCoordinates);
    polylines.add(polyline);

    notifyListeners();
    setBusy(false);

  }



  Future setMapPins(LatLng addressFrom, LatLng addressTo) async{
    _markers.removeWhere((element) => element.markerId.value == 'sourcePin');
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: LatLng(addressFrom.latitude, addressFrom.longitude),
        ));
    // destination pin
    var dest = _markers.firstWhere((element) => element.markerId.value == 'destPin', orElse: ()=> null);
    if(dest == null || dest == false ){
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: LatLng(addressTo.latitude, addressTo.longitude),
          ));
    }
  }




  Future updateProfile(Map<String, dynamic> data, String id) async {
    try {
      return await _firestoreService.updateUser(data, id);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }


  Future setTrip(AddressesTrip addressFrom, AddressesTrip addressTo) async {
    listenToDrivers(addressFrom);
    LatLng addressFromVar = LatLng(addressFrom.lat, addressFrom.lng);
    LatLng addressToVar = LatLng(addressTo.lat, addressTo.lng);
    polylineCoordinates = [];
    polylines = {};
    _markers = {};

      await setMapPins(addressFromVar, addressToVar);
      await setPolylines(addressFromVar, addressToVar);

       _money = calculateRate(1740.00);

    await cameraAnimated(addressFromVar, addressToVar);
    Timer(Duration(seconds: 2), (){
      if(!controllerSliding.isOpened){
        controllerSliding.show();
        print('2 segundos');
      }
    });

  }

  cameraAnimated(LatLng addressFrom, LatLng addressTo) async{
     GoogleMapController controller = await googleMapController.future;

    GEO.LatLng midPoint = getCenterLocation(addressFrom, addressTo);

    initialLocation = CameraPosition(
        zoom: 12.0,
        bearing: 30,
        tilt: 0,
        target: LatLng(midPoint.latitude, midPoint.longitude)
    );
    notifyListeners();
     controller.animateCamera(CameraUpdate.newCameraPosition(
       initialLocation
     ));
     notifyListeners();



  }


   double calculateRate(double rate)  {
      //double rate = 1640;
      double distance = 0.0;

      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        distance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }
      return distance * rate;
  }

   double calculateDistance()  {
      //double rate = 1640;
      double distance = 0.0;
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        distance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }
      return distance;
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }


  Future createdTrip(User driver, Vehicle vehicle, AddressesTrip pick, AddressesTrip drop, BuildContext context ) async{
    try{
      var response = await _firestoreService.createTrip(Trip(
        status: EnumToString.parse(StatusTrip.Initial),
        type: 'uber',
        professionalId: driver.id,
        amountProduct: null,
        description: null,
        user: currentUser,
        kilometres: calculateDistance(),
        total: calculateRate(vehicle.price.toDouble()),
        product: null,
        createdAt: FieldValue.serverTimestamp(),
        pickLocation: pick,
        dropLocation: drop,
      ));
      if(response != null){
        print(response);
        await updateProfile(
            {'busy': true}
            ,
            driver.id.toString());
        Navigator.of(context).pushNamed('/TransactionCab', arguments: RouteArgument(
          id: response.id,
          param: calculateRate(vehicle.price.toDouble()).toInt().toString()
        )
        );
      }

    } catch(e){

    }

  }


}