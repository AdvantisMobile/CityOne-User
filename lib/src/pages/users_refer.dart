import 'package:flutter/material.dart';
import 'package:markets/src/elements/CircularLoadingWidget.dart';
import 'package:markets/src/elements/ShoppingCartButtonWidget.dart';
import 'package:markets/src/models/route_argument_user.dart';
import 'package:markets/src/viewmodels/refer_user_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:tree_view/tree_view.dart';

class UsersReferWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReferUserModels>.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => ReferUserModels(),
        onModelReady: (model) {
          model.getReferUser();
        },
        builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Mis referidos',
              style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
            ),
            actions: <Widget>[
              new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
            ],
          ),
          body: model.tree == null ? CircularLoadingWidget(height: 500,): TreeView(
            hasScrollBar: true,
            parentList: model.tree.children.map((e) {
              return Parent(
                parent: Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(e.name, style: TextStyle(fontSize: 18, color: Colors.black54),),
                    leading: Icon(Icons.looks_one),
                    trailing: e.children.length > 0 ? Icon(Icons.navigate_next) : SizedBox(),
                  ),
                ), childList: ChildList(
                  children: e.children.map((user) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Card(
                        elevation: 2,
                        child: ListTile(
                          leading: Icon(Icons.looks_two),
                          title: Text(user.name, style: TextStyle(fontSize: 18, color: Colors.black54),),
                        ),
                      ),
                    );
                  }).toList(),
              ),
              );
            }).toList()
          ),
        );
      }
    );
  }
}
