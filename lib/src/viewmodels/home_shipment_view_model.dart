import 'dart:async';
import 'dart:ui';
import 'dart:math' show cos, sqrt, asin;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

class HomeShipmentViewModels extends BaseModel {
  GlobalKey<ScaffoldState> scaffoldKey;

  final firestoreService _firestoreService = locator<firestoreService>();
  final geof = geofire.Geoflutterfire();


  GlobalKey<FormState> tripFormKey;

  Trip trip = new Trip();
  int vehicleId;

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
      if (_vehicle.role == 'messenger') {
        vehicles.add(_vehicle);
        notifyListeners();
      }
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }


  void initScaffold(){
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.tripFormKey = new GlobalKey<FormState>();

  }

  void listenToDrivers(AddressesTrip addressFrom) {
    setBusy(true);
    geofire.GeoFirePoint fromLocation = geof.point(latitude: addressFrom.lat, longitude: addressFrom.lng);
    _firestoreService.listenToUsersLocationRealTime('messenger', fromLocation ).listen((tripData) {
      List<User> updatedTrips = tripData;
      print('######### user #############');
      if (updatedTrips != null && updatedTrips.length > 0) {
        print(updatedTrips);
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

    print(calculateRate(1740.00));

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


  Future createdTrip( BuildContext context ) async{
    try{
      var response = await _firestoreService.createTrip(trip);
      if(response != null){
        print(response);
        await _firestoreService.updateUser({'busy': true}, trip.professionalId);
        Navigator.of(context).pushNamed('/TransactionCab', arguments: RouteArgument(
            id: response.id,
            param: trip.total.toInt().toString()
        )
        );
      }

    } catch(e){

    }

  }

  bool validateForm() {
    final form = tripFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateTrip(AddressesTrip addressFrom, AddressesTrip addressTo) {
    print(validateForm());
    User driver = null;
    Vehicle vehicle = vehicles.firstWhere((element) => element.id == vehicleId, orElse: () => null);
    notifyListeners();

    if(_drivers != null ){
      driver = _drivers.firstWhere((element) => element.typeId == vehicleId, orElse: () => null);
      if(driver == null){
        print('··············paso ·············');
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text('No hay usuarios disponibles para este vehiculo'),
        ));
      }
    }else{
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('No hay usuarios disponibles para este vehiculo'),
      ));
    }

    if(validateForm() && addressFrom != null && addressTo != null && vehicleId != null && vehicle != null && driver != null){
      tripFormKey.currentState.save();
      trip.total = (trip.amountProduct * 0.10) + calculateRate(vehicle.price.toDouble());
      trip.kilometres = calculateDistance();
      trip.type = 'messenger';
      trip.status = 'Initial';
      trip.createdAt = FieldValue.serverTimestamp();
      trip.user = currentUser;
      trip.professionalId = driver.id;
      trip.pickLocation = addressFrom;
      trip.dropLocation = addressTo;


      notifyListeners();
    }
  }



  void changeVehicle(int value) {
    vehicleId = value;
    notifyListeners();
  }


}