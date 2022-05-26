import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart' as userRepo;


class PaymentCabController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  PaymentCabController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  @override
  void initState() {

    final String _apiToken = 'api_token=${userRepo.currentUser.value.apiToken}';

    url =
    '${GlobalConfiguration().getString('base_url')}payments/redeban/trip?$_apiToken&';

    setState(() {});
    super.initState();
  }
}
