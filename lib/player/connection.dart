import 'package:flutter/material.dart';
import 'package:vscreen_client_core/vscreen.dart' as v;
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
  v.VScreenBloc _vscreen;

  Widget _buildForm({String error}) {
    _portController.text = "8080";

    var rows = <Widget>[];
    if (error != null) {
      rows.add(Text(error, style: TextStyle(color: Colors.red)));
    }

    rows.addAll([
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
    ]);

    return AlertDialog(
      title: Text('Connect to'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: rows,
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
          },
          child: Text("connect"),
        )
      ],
    );
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

            if (state is v.Connecting) {
              return Center(
                  child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ));
            }
          }

          return _buildForm(
              error: snapshot.hasError ? snapshot.error.toString() : null);
        });
  }
}
