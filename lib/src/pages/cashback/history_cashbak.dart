import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryCashBak extends StatelessWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HistoryCashBak({Key key, this.parentScaffoldKey}) : super(key: key);



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
    ItemData(amount: 60000.00, type: 'Cashbak', entry: true, status: 'Aceptada'),
    ItemData(amount: 4000.00, type: 'Compra', entry: true, status: 'Aceptada'),
    ItemData(amount: 25000.00, type: 'Compra', entry: true, status: 'Aceptada'),
    ItemData(amount: 45000.00, type: 'Compra', entry: true, status: 'Aceptada'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Movimientos'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children:  _listData.map((e) => _itemList(e)).toList(),
          ),
        )
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
