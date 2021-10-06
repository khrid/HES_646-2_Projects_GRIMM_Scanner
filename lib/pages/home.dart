import 'package:flutter/material.dart';
import 'package:grimm_scanner/widgets/custom_drawer.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.title}) : super(key : key);
  final String title;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("GRIMM Scanner"),
      ),
      drawer: const CustomDrawer(),
    );
  }
}