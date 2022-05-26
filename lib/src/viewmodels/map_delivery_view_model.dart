
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:markets/src/models/user.dart';
import 'package:markets/src/services/firestore_service.dart';
import 'package:markets/src/viewmodels/base_model.dart';
import 'package:markets/src/repository/user_repository.dart' as userRepo;
import 'package:flutter_animarker/lat_lng_interpolation.dart';
import 'package:flutter_animarker/models/lat_lng_delta.dart';

import 'package:markets/locator.dart';

class MapDeliveryModels extends BaseModel {
  final firestoreService _firestoreService = locator<firestoreService>();

  LatLng initialLocationController;


  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  final polygon = <LatLng>[
    LatLng(6.256464, -75.568917),
    LatLng(6.255291, -75.569108),

  ];

  final Completer<GoogleMapController> controller = Completer();

  LatLngInterpolationStream latLngStream = LatLngInterpolationStream(
    movementDuration: Duration(milliseconds: 2000),
  );

  MarkerId sourceId = MarkerId("SourcePin");

  StreamSubscription<LatLngDelta> subscription;
  final startPosition = LatLng(6.256251, -75.567909);

  User userFirebase;
  void init(){

    subscription = latLngStream.getLatLngInterpolation().listen(( delta) {
          print('prueba..........................');
          LatLng from = delta.from;
          print("To: -> ${from.toJson()}");
          LatLng to = delta.to;
          print("From: -> ${to.toJson()}");
          double angle = delta.rotation;
          print("Angle: -> $angle");
          //Update the animated marker

          Marker sourceMarker = Marker(
            markerId: sourceId,
            rotation: delta.rotation,
            position: LatLng(
              delta.from.latitude,
              delta.from.longitude,
            ),
          );
          var dest = _markers.firstWhere((element) => element.markerId.value == sourceId.value, orElse: ()=> null);

          if(dest != null){
            _markers.remove(sourceId);
          }
          _markers.add(sourceMarker);
          notifyListeners();

        });
  }



  void listenUser(String driverId) {
    print(driverId);
    //latLngStream.addLatLng(LatLng(3.7135652, -75.8697014));

    _firestoreService.getUserStream(driverId).listen((userData)  {
      User updateUser = userData;
      if(updateUser != null && updateUser.turn){
        userFirebase = updateUser;
        if(updateUser.coordinates != null){
          print('........................................................................');
          latLngStream.addLatLng(LatLng(updateUser.coordinates.latitude, updateUser.coordinates.longitude));
        }
        notifyListeners();
        print('prueba User..........................');

        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();

    // TODO: implement dispose
    super.dispose();
    print('dipose');
  }



}