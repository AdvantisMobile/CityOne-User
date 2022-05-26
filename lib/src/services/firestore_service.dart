
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:markets/src/models/trip_model.dart';
import 'package:markets/src/models/user.dart';
import 'package:geoflutterfire/geoflutterfire.dart';


class firestoreService{

  // professionals model
  final geo = Geoflutterfire();

  final CollectionReference _tripCollectionReference =
  FirebaseFirestore.instance.collection('trips');

  final StreamController<List<Trip>> _tripController =
  StreamController<List<Trip>>.broadcast();

  final StreamController<Trip> _tripUniqueController =
  StreamController<Trip>.broadcast();


  final CollectionReference _userCollectionReference =
  FirebaseFirestore.instance.collection('users');

  final StreamController<List<User>> _userController =
  StreamController<List<User>>.broadcast();


  final StreamController<User> _useruniqueController =
  StreamController<User>.broadcast();



  Stream listenToTripsRealTime(String userId, String type) {
    // Register the handler for when the posts data changes
    _tripCollectionReference
        .where('user.id', isEqualTo: userId).where('type', isEqualTo: type)
        .snapshots()
        .listen((tripSnapshot) {
      if (tripSnapshot.docs.isNotEmpty) {
        var jobs = tripSnapshot.docs
            .map((snapshot) => Trip.fromJson(snapshot.data(), snapshot.id))
            .toList();
        // Add the posts onto the controller
        _tripController.add(jobs);
      }
    });
    return _tripController.stream;
  }


  Stream listenToTripIdRealTime(String id) {
    _tripCollectionReference.doc(id).snapshots().listen((userSnapshot) {
      if (userSnapshot.exists) {
        var user = Trip.fromJson(userSnapshot.data(), userSnapshot.id);
        _tripUniqueController.add(user);
      }
    });
    return _tripUniqueController.stream;
  }


  Future createTrip(Trip trip) async {
    try {
     return await _tripCollectionReference.add(trip.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }


  Future getUsersOnceOff(String role) async {
    try {
      var usersDocumentSnapshot = await _userCollectionReference
          .where('turn', isEqualTo: true).where('role', isEqualTo: role)
          .get();
      if (usersDocumentSnapshot.docs.isNotEmpty) {
        return usersDocumentSnapshot.docs
            .map((snapshot) => User.fromJSON(snapshot.data()))
            .toList();
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future updateUser(Map<String, dynamic> data, String id) async {
    try {
      await _userCollectionReference.doc(id).update(data);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }


  Stream listenToUsersLocationRealTime(String role, GeoFirePoint  center ) {
    // Register the handler for when the posts data changes
    geo.collection(collectionRef: _userCollectionReference
        .where('turn', isEqualTo: true).where('role', isEqualTo: role).where('busy', isEqualTo: false))
        .within(center: center, radius: 10, field: 'coordinates').listen((userSnapshot) {
          print(userSnapshot);
      if (userSnapshot.isNotEmpty) {
        var user = userSnapshot
            .map((snapshot) => User.fromJSON(snapshot.data()))
            .toList();
        print(user);
        // Add the posts onto the controller
        _userController.add(user);
      }
    });

    return _userController.stream;
  }

  Stream getUserStream(String id) {
    _userCollectionReference.doc(id).snapshots().listen((userSnapshot) {
      if (userSnapshot.exists) {
        print('####################################################################');
        var user = User.fromJSON(userSnapshot.data());
        _useruniqueController.add(user);
      }
    });
    return _useruniqueController.stream;
  }


}