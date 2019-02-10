import 'package:vscreen_client_core/vscreen.dart';
import 'package:flutter/material.dart';

class VScreen extends InheritedWidget {
  final VScreenBloc bloc;

  VScreen({this.bloc, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static VScreen of([BuildContext context, rebuild = true]) {
    return context.inheritFromWidgetOfExactType(VScreen);
  }
}
