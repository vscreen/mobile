import 'package:flutter/material.dart';
import 'player/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vscreen_client_core/vscreen_client_core.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final VScreenBloc _vscreenBloc = VScreenBloc();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'VScreen',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: PlayerWidget());
  }

  @override
  void dispose() {
    _vscreenBloc.dispose();
    super.dispose();
  }
}
