import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/media.dart';

class User {
  String id;
  String name;
  String email;
  String password;
  String apiToken;
  String deviceToken;
  String phone;
  String address;
  String bio;
  Media image;
  bool busy;
  int typeId;
  // used for indicate if client logged in or not
  bool auth;
  bool turn;
  String role;

  String referCode;
  String refer;
  GeoPoint coordinates;

//  String role;

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'] != null ? jsonMap['name'] : '';
      email = jsonMap['email'] != null ? jsonMap['email'] : '';
      apiToken = jsonMap['api_token'];
      deviceToken = jsonMap['device_token'];
      referCode = jsonMap['refer_code'] ?? '';
      refer = jsonMap['refer_code'] ?? '' ;
      role = jsonMap['role'] ?? '' ;
      turn = jsonMap['turn'] ?? false;
      busy = jsonMap['busy'] ?? false;
      typeId = jsonMap['typeId'] ?? 0;
      if( jsonMap['coordinates'] != null){
        //print(jsonMap['coordinates']['geopoint']);
        coordinates = jsonMap['coordinates']['geopoint'];
      }
      try {
        phone = jsonMap['custom_fields']['phone']['view'];
      } catch (e) {
        phone = "";
      }
      try {
        address = jsonMap['custom_fields']['address']['view'];
      } catch (e) {
        address = "";
      }
      try {
        bio = jsonMap['custom_fields']['bio']['view'];
      } catch (e) {
        bio = "";
      }
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
    } catch (e) {
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["password"] = password;
    map["api_token"] = apiToken;
    map["refer_code"] = referCode;
    map["refer"] = refer;
    if (deviceToken != null) {
      map["device_token"] = deviceToken;
    }
    map["phone"] = phone;
    map["address"] = address;
    map["bio"] = bio;
    map["busy"] = busy;
    map["media"] = image?.toMap();
    return map;
  }

  Map toMapFirebase() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["password"] = password;
    map["api_token"] = apiToken;
    map["role"] = role;
    if(turn != null){
      map['turn'] = turn;
    }else{
      map['turn'] = false;
    }
    if (deviceToken != null) {
      map["device_token"] = deviceToken;
    }
    map["phone"] = phone;
    map["address"] = address;
    map["bio"] = bio;
    map["media"] = image?.toMap();

    if (coordinates != null) {
      map['coordinates'] = coordinates;
    }
    return map;
  }


  @override
  String toString() {
    var map = this.toMap();
    map["auth"] = this.auth;
    return map.toString();
  }

  bool profileCompleted() {
    return address != null && address != '' && phone != null && phone != '';
  }

}

// class Coordinates {
//   double latitude;
//   double longitude;
//
//   Coordinates({this.latitude, this.longitude});
//
//   Coordinates.fromJson(Map<String, dynamic> json) {
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     return data;
//   }
// }
