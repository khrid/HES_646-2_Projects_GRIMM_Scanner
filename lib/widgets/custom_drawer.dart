import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
              child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _createHeader(),
            ],
          )),
          _createStickyBottomItems()
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image:
                    AssetImage('assets/images/drawer_header_background.png'))),
        child: Stack(children: const <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("GRIMM scanner",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

    _createStickyBottomItems() {
    return Align(
        alignment: FractionalOffset.bottomCenter,
        // This container holds all the children that will be aligned
        // on the bottom and should not scroll with the above ListView
        child: Column(
          children: const <Widget>[
        Divider(),
        ListTile(
          title: Text("0.0.2"),
        )
          ],
        ));
  }
}
