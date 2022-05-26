import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {
  //ProfileController _con;

  _DrawerWidgetState() : super(ProfileController()) {
    //_con = controller;
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentUser.value.apiToken != null ? Navigator.of(context).pushNamed('/Profile') : Navigator.of(context).pushNamed('/Login');
            },
            child: currentUser.value.apiToken != null
                ? UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    accountName: Text(
                      currentUser.value.name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    accountEmail: Text(
                      currentUser.value.email,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      backgroundImage: NetworkImage(currentUser.value.image.thumb),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 32,
                          color: Theme.of(context).accentColor.withOpacity(1),
                        ),
                        SizedBox(width: 30),
                        Text(
                          S.of(context).guest,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 2);
            },
            leading: Icon(
              Icons.fastfood,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              'Comercios',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/cashbak', arguments: 1);
            },
            leading: Icon(
              Icons.credit_card,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              'Cashback',
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/cab', arguments: 1);
            },
            leading: Icon(
              Icons.drive_eta,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              'Viajes',
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/shipment', arguments: 1);
            },
            leading: Icon(
              Icons.send,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              'Envios',
              style: Theme.of(context).textTheme.subhead,
            ),
          ),

          ListTile(
            dense: true,
            title: Text(
              S.of(context).application_preferences,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Help');
            },
            leading: Icon(
              Icons.help,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).help__support,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                Navigator.of(context).pushNamed('/Settings');
              } else {
                Navigator.of(context).pushReplacementNamed('/Login');
              }
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).settings,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Languages');
            },
            leading: Icon(
              Icons.translate,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).languages,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (Theme.of(context).brightness == Brightness.dark) {
                setBrightness(Brightness.light);
                setting.value.brightness.value = Brightness.light;
              } else {
                setting.value.brightness.value = Brightness.dark;
                setBrightness(Brightness.dark);
              }
              setting.notifyListeners();
            },
            leading: Icon(
              Icons.brightness_6,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              Theme.of(context).brightness == Brightness.dark ? S.of(context).light_mode : S.of(context).dark_mode,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () async{
              await launch('https://cityone.com.co');
            },
            leading: Icon(
              Icons.link,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              'Registre su negocio',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),

          // todo
          ListTile(
            onTap: () async{
              await launch('https://cityone.com.co');
            },
            leading: Icon(
              Icons.link,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              'Ser domiciliario',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),

          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                logout().then((value) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/Pages', (Route<dynamic> route) => false, arguments: 2);
                });
              } else {
                Navigator.of(context).pushNamed('/Login');
              }
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              currentUser.value.apiToken != null ? S.of(context).log_out : S.of(context).login,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          currentUser.value.apiToken == null
              ? ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/SignUp');
                  },
                  leading: Icon(
                    Icons.person_add,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    S.of(context).register,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                )
              : SizedBox(height: 0),
          setting.value.enableVersion
              ? ListTile(
                  dense: true,
                  title: Text(
                    S.of(context).version + " " + setting.value.appVersion,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: Icon(
                    Icons.remove,
                    color: Theme.of(context).focusColor.withOpacity(0.3),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
