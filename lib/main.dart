import 'package:flutter/material.dart';
import 'player/player.dart';
import 'package:vscreen_client_core/vscreen.dart';
import './inherited.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final _vscreenBloc = VScreenBloc();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return VScreen(
        bloc: _vscreenBloc,
        child: MaterialApp(
            title: 'VScreen',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            home: Scaffold(
                body: PlayerWidget(), resizeToAvoidBottomPadding: false)));
  }

  @override
  void dispose() {
    _vscreenBloc.dispose();
    super.dispose();
  }
}
