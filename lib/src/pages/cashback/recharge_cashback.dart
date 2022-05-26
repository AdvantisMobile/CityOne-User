import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class RechargeCashBack extends StatefulWidget {

  @override
  _RechargeCashBackState createState() => _RechargeCashBackState();
}

class _RechargeCashBackState extends State<RechargeCashBack> {

  double _amount = 50000.00;
  String _method = 'card';

  NumberFormat _money = NumberFormat.currency(
    locale: 'es',
    symbol: 'COP',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recargar'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0,),
            Center(
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors:[Colors.green, Colors.lightGreen,  Colors.green]
                    )
                ),
                child: Text('Saldo: ${_money.format(64300.00)}', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white70,),),
              ),
            ),
            SizedBox(height: 10.0,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: DropdownButton(
                isExpanded: true,
                elevation: 1,
                  items: [
                    DropdownMenuItem(
                        child: Text("Tarjeta de credito"),
                        value: 'card' ,
                    ),
                    DropdownMenuItem(
                        child: Text("PSE"),
                        value: 'PSE' ,
                    ),
                  ],
                  onChanged: (value){
                    setState(() {
                      _method = value;
                    });
                  },
                  value: _method,
              ),
            ),

            SizedBox(height: 10.0,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: DropdownButton(
                isExpanded: true,
                elevation: 1,
                items: [
                  DropdownMenuItem(
                    child: Text("${_money.format(50000.00)}"),
                    value: 50000.00 ,
                  ),
                  DropdownMenuItem(
                    child: Text("${_money.format(100000.00)}"),
                    value: 100000.00 ,
                  ),
                  DropdownMenuItem(
                    child: Text("${_money.format(150000.00)}"),
                    value: 150000.00 ,
                  ),
                  DropdownMenuItem(
                    child: Text("${_money.format(200000.00)}"),
                    value: 200000.00 ,
                  ),
                ],
                onChanged: (value){
                  setState(() {
                    _amount = value;
                  });
                },
                value: _amount,
              ),
            ),


            SizedBox(height: 20.0,),

            Center(
              child: InkWell(
                onTap: (){
                },
                focusColor: Colors.black54,
                hoverColor: Colors.black54,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                          colors: [Colors.green, Colors.lightGreen,  Colors.green]
                      )
                  ),
                  height: 40.0,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Center(child: Text('RECARGAR', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),)),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
