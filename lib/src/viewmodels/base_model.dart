



import 'dart:async';

import 'package:flutter/material.dart';
import 'package:markets/src/models/user.dart';
import '../repository/user_repository.dart' as userRepo;

class BaseModel extends ChangeNotifier {
  User get currentUser => userRepo.currentUser.value;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    if(value){
      Timer(Duration(seconds: 6), () {
        if(busy){
          print('auto disable buse');
          _busy = false;
          notifyListeners();
        }
      });
    }
    notifyListeners();
  }
}