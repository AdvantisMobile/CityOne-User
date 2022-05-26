
import 'dart:async';
import 'dart:ui';
import 'dart:math' show cos, sqrt, asin;


import 'package:markets/src/models/trip_model.dart';
import 'package:markets/src/services/firestore_service.dart';
import 'package:markets/src/viewmodels/base_model.dart';


import 'package:markets/locator.dart';

class TransactionViewModels extends BaseModel {
  final firestoreService _firestoreService = locator<firestoreService>();
  Trip _trip;
  Trip get trip => _trip;

  void listenToTrip(String id) {
    setBusy(true);
      _firestoreService.listenToTripIdRealTime(id).listen((tripData) {
        Trip updatedTrips = tripData;
        if (updatedTrips != null) {
          _trip = updatedTrips;
          notifyListeners();
        }
        setBusy(false);
});
}


}