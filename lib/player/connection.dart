import 'package:flutter/material.dart';
import 'package:vscreen_client_core/vscreen.dart';
import '../inherited.dart';

class ConnectionDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConnectionDialogState();
  }
}

class ConnectionDialogState extends State<ConnectionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  VScreenBloc _vscreen;

  @override
  Widget build(BuildContext context) {
    _vscreen = VScreen.of(context).bloc;

    return AlertDialog(
      title: Text('Connect to'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _ipController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "IP address"),
              ),
              TextFormField(
                controller: _portController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Port"),
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("cancel"),
        ),
        FlatButton(
          onPressed: () {
            var url = _ipController.text;
            var port = int.parse(_portController.text);
            _vscreen.connect(url, port);
            Navigator.pop(context);
          },
          child: Text("connect"),
        )
      ],
    );
  }
}
