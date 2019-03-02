import 'package:flutter/material.dart';
import 'package:vscreen_client_core/vscreen.dart' as v;
import 'dart:async';
import '../inherited.dart';

class ConnectionDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConnectionDialogState();
  }
}

class ConnectionDialogState extends State<ConnectionDialog> {
  v.VScreenBloc _vscreen;

  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      print("Discovering");
      VScreen.of(context).bloc.startDiscovering();
    });
  }

  @override
  Widget build(BuildContext context) {
    _vscreen = VScreen.of(context).bloc;

    return StreamBuilder<v.ConnectionState>(
        stream: _vscreen.connection.skip(1),
        initialData: v.Disconnected(),
        builder: (context, snapshot) {
          if (!snapshot.hasError) {
            var state = snapshot.data;

            if (state is v.Connected) {
              return AlertDialog(content: Text("connected"));
            }

            if (state is v.Discovered) {
              return AlertDialog(
                content: ListView(
                  children: state.services.map((connection) {
                    return ListTile(
                      title: Text(connection.host),
                      onTap: () {
                        _vscreen.connect(connection.host, connection.port);
                      },
                    );
                  }).toList(),
                ),
              );
            }
          }

          return Center(
              child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(),
          ));
        });
  }
}
