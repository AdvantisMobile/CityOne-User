import 'package:flutter/material.dart';
import 'package:markets/src/controllers/profile_controller.dart';
import 'package:markets/src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:markets/src/widgets/card_widget.dart';
import 'package:intl/intl.dart';


import '../../repository/settings_repository.dart' as settingsRepo;


class HomeCashBack extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeCashBack({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeCashBackState createState() => _HomeCashBackState();
}

class _HomeCashBackState extends StateMVC<HomeCashBack> {

  ProfileController _con;
  List<String> _iniciales;

  _HomeCashBackState() : super(ProfileController()) {
    _con = controller;
  }


  NumberFormat _money = NumberFormat.currency(
    locale: 'es',
    symbol: 'COP',
    decimalDigits: 2,
  );


  List<ItemData> _listData = [
    ItemData(amount: 250000.00, type: 'Recarga', entry: true, status: 'Aceptada'),
    ItemData(amount: 30000.00, type: 'Compra', entry: false, status: 'Aceptada'),
    ItemData(amount: 5400.00, type: 'Compra', entry: false, status: 'Pendiente'),
    ItemData(amount: 5500.00, type: 'Compra', entry: false, status: 'Aceptada'),
    ItemData(amount: 29000.00, type: 'Compra', entry: false, status: 'Aceptada'),
    ItemData(amount: 60000.00, type: 'Cashbak', entry: true, status: 'Aceptada'),
    ItemData(amount: 4000.00, type: 'Compra', entry: true, status: 'Aceptada'),
    ItemData(amount: 25000.00, type: 'Compra', entry: true, status: 'Aceptada'),
    ItemData(amount: 45000.00, type: 'Compra', entry: true, status: 'Aceptada'),
    ItemData(amount: 7000.00, type: 'Compra', entry: true, status: 'Aceptada'),
  ];

@override
  void initState() {
    // TODO: implement initState
  _iniciales = currentUser.value.name.split(" ");

  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              'CityOne',
              style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10.0),
          child: currentUser.value.apiToken != null
          ?
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 25.0,),
                  _customAvatar(),
                  SizedBox(width: 20.0,),
                  Text('Bienvenido', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),)
                ],
              ),


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


              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                height: 210.0,

                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black45, spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(8, 8)),

                  ],
                  gradient: LinearGradient(
                      colors: [Colors.black, Colors.black54, Colors.black87]
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: BankCard(),

              ),
               SizedBox(height: 10.0,),
               Center(
                 child: InkWell(
                   onTap: (){
                      Navigator.of(context).pushNamed('/Recharge');
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
               SizedBox(height: 10.0,),
               Center(
                 child: Text('Ultimos registros.', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black54),),
               ),
               SizedBox(height: 10.0,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _listData.map((e) => _itemList(e)).toList(),
              )
            ],
          )
              :
              Center(
                child: Text('Inicia sesión'),
              )
      )

    );
  }

  Widget _customAvatar()  {
    String letras;
    if(_iniciales.length >= 2){
      letras = "${_iniciales[0][0]}${_iniciales[_iniciales.length -1][0]}";
    }else{
      letras = "${_iniciales[0][0]}";
    }
    print(letras);


    return CircleAvatar(
      child: Text(letras, style: TextStyle(fontSize: 20.0),),
    );
  }
  
  
  Widget _itemList(ItemData itemData){
    var color = itemData.entry ? Colors.green : Colors.red;
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(Icons.attach_money, color: color, size: 60.0,),
        title: Text("${itemData.type}: ${itemData.status}", style: TextStyle(color: color, fontSize: 20.0, fontWeight: FontWeight.bold),),
        subtitle: Text("${_money.format(itemData.amount)}", style: TextStyle(color: color, fontSize: 18.0, fontWeight: FontWeight.bold),),
        trailing: Icon(itemData.entry ? Icons.add_circle : Icons.remove_circle, size: 60.0, color: color,),
      ),
    );
  }


}


class ItemData{
  double amount;
  String status;
  String type;
  bool entry;

  ItemData({this.amount, this.status, this.type, this.entry});
}
