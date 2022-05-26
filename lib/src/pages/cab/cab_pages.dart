import 'package:flutter/material.dart';
import 'package:markets/src/elements/DrawerWidget.dart';
import 'package:markets/src/pages/cab/history_cab.dart';
import 'package:markets/src/pages/cab/home_cab.dart';
import 'package:markets/src/pages/notifications.dart';



// ignore: must_be_immutable
class CabPages extends StatefulWidget {
  int currentTab;
  Widget currentPage = HomeCab();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();


  CabPages({
    Key key,
    this.currentTab,
  }) {
    currentTab = currentTab != null ? currentTab : 1;
  }

  @override
  _CabPagesState createState() => _CabPagesState();
}

class _CabPagesState extends State<CabPages> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(CabPages oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: widget.scaffoldKey,
          drawer: DrawerWidget(),
          body: widget.currentPage,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).accentColor,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            iconSize: 22,
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedIconTheme: IconThemeData(size: 28),
            unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
            currentIndex: widget.currentTab,
            onTap: (int i) {
              this._selectTab(i);
            },
            // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                title: new Container(height: 0.0),
              ),
              BottomNavigationBarItem(
                  title: new Container(height: 5.0),
                  icon: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
                        BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
                      ],
                    ),
                    child: new Icon(Icons.map, color: Theme.of(context).primaryColor),
                  )),

              BottomNavigationBarItem(
                icon: new Icon(Icons.history),
                title: new Container(height: 0.0),
              ),
            ],
          ),

        )
    );

  }




  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch(tabItem){
        case 0:
          widget.currentPage = NotificationsWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 1:
          widget.currentPage = HomeCab(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 2:
          widget.currentPage = HistoryCab(parentScaffoldKey: widget.scaffoldKey);
          break;
      }
    });
  }


}
