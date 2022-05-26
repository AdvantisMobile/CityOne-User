import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:markets/src/controllers/redeban_controller.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/route_argument.dart';

// ignore: must_be_immutable
class RedebanPaymentWidget extends StatefulWidget {
  RouteArgument routeArgument;
  RedebanPaymentWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _RedebanPaymentWidgetState createState() => _RedebanPaymentWidgetState();
}

class _RedebanPaymentWidgetState extends StateMVC<RedebanPaymentWidget> {
  RedebanController _con;
  _RedebanPaymentWidgetState() : super(RedebanController()) {
    _con = controller;
  }
  String total;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      total = widget.routeArgument.id;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            initialUrl:'${_con.url}trip=${total}',
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
                Navigator.of(context).pushReplacementNamed('/Pages', arguments: 3);
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
