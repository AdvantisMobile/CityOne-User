
import 'package:markets/src/models/trip_model.dart';
import 'package:markets/src/services/firestore_service.dart';
import 'package:markets/src/viewmodels/base_model.dart';


import 'package:markets/locator.dart';

class HistoryShipmentViewModels extends BaseModel {
  final firestoreService _firestoreService = locator<firestoreService>();
  List<Trip> _trips;
  List<Trip> get trips => _trips;

  void listenToTrips() {
    setBusy(true);
    _firestoreService.listenToTripsRealTime(currentUser.id, 'messenger').listen((tripData) {
      List<Trip> updatedTrips = tripData;
      if (updatedTrips != null) {
        _trips = updatedTrips;
        notifyListeners();
      }
      setBusy(false);
    });
  }


}