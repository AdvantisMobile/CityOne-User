import 'package:markets/src/config/size.dart';
import 'package:flutter/material.dart';

class BankCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    double fontSize(double size) {
      return size * width / 414;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width / 20, vertical: height / 20),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                alignment: Alignment.topLeft,
                width: width / 1.8,
                child: Image.asset(
                  "assets/img/logo.png",
                  height: 50.0,
                  fit: BoxFit.fill,
                )),
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: height / 10,
                width: width / 1.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "**** **** **** ",
                          style: TextStyle(
                              fontSize: fontSize(20),
                              fontWeight: FontWeight.w500, color: Colors.white70),
                        ),
                        Text(
                          "1930",
                          style: TextStyle(
                              fontSize: fontSize(30),
                              fontWeight: FontWeight.w500, color: Colors.white70),
                        )
                      ],
                    ),
                    Text(
                      "Platinum Card".toUpperCase(),
                      style: TextStyle(
                          fontSize: fontSize(15), fontWeight: FontWeight.bold, color: Colors.white70),
                    )
                  ],
                ),
              )
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white70, Colors.white54, Colors.blueGrey]
                ),
                borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.all(12.0),
              width: width / 4,
              height: height / 16,
              child: Image.asset(
                "assets/img/visa.png",
                height: 20.0,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 List<BoxShadow> _neumorpShadow = [
  BoxShadow(
      color: Colors.white.withOpacity(0.5), spreadRadius: -5, offset: Offset(-5, -5), blurRadius: 30),
  BoxShadow(
      color: Colors.blue[900].withOpacity(.2),
      spreadRadius: 2,

      offset: Offset(7, 7),
      blurRadius: 20)
];