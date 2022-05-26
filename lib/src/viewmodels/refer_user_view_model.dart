
import 'package:flutter/material.dart';
import 'package:markets/src/models/tree_model.dart';
import 'package:markets/src/services/firestore_service.dart';
import 'package:markets/src/viewmodels/base_model.dart';
import 'package:markets/src/repository/user_repository.dart' as userRepo;

import 'package:markets/locator.dart';

class ReferUserModels extends BaseModel {
  final firestoreService _firestoreService = locator<firestoreService>();
  Tree _tree;
  Tree get tree => _tree;

  Future getReferUser() async {
    try{
      _tree = await userRepo.getUserRefer();
      notifyListeners();
      print(_tree.children[0].name);
    }catch(e){
      print(e);
    }
  }



}