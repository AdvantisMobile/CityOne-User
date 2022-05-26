import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:markets/src/controllers/payment_cab_controller.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../models/route_argument.dart';

// ignore: must_be_immutable
class PaymentCabWidget extends StatefulWidget {
  RouteArgument routeArgument;
  PaymentCabWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _PaymentCabWidgetState createState() => _PaymentCabWidgetState();
}

class _PaymentCabWidgetState extends StateMVC<PaymentCabWidget> {
  PaymentCabController _con;
  _PaymentCabWidgetState() : super(PaymentCabController()) {
    _con = controller;
   // print(widget.routeArgument.param);


  }
  String id;
  String total;


  @override
  void initState() {
    super.initState();
    setState(() {
      id = widget.routeArgument.id;
      total = widget.routeArgument.param;
    });
  }


  @override
  Widget build(BuildContext context) {
    print('trip=${id}&total=${total}');
    print(_con.url);

    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Redeban',
          style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: Stack(
        children: <Widget>[
          InAppWebView(
            initialUrl:  '${_con.url}trip=${id}&total=${total}',
            initialHeaders: {},
            initialOptions: InAppWebViewWidgetOptions(),
            onWebViewCreated: (InAppWebViewController controller) {
              print(controller);
              _con.webView = controller;
            },
            onLoadStart: (InAppWebViewController controller, String url) {
              setState(() {
                _con.url = url;
              });
              if (url == "${GlobalConfiguration().getString('base_url')}payments/redeban") {
                Navigator.of(context).pop();
              }
            },
            onProgressChanged: (InAppWebViewController controller, int progress) {
              setState(() {
                _con.progress = progress / 100;
              });
            },
          ),
          _con.progress < 1
              ? SizedBox(
            height: 3,
            child: LinearProgressIndicator(
              value: _con.progress,
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
            ),
          )
              : SizedBox(),
        ],
      ),
    );
  }
}
