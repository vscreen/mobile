import 'package:flutter/material.dart';
import 'dart:ui';
import './connection.dart';
import 'package:flutter/services.dart';
import 'package:vscreen_client_core/vscreen.dart' as v;
import '../inherited.dart';
import 'dart:async';

class PlayerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget>
    with WidgetsBindingObserver {
  v.VScreenBloc _vscreen;

  _PlayerWidgetState() {
    const _platform = const MethodChannel('app.channel.shared.data');
    _platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == "getSharedURL") {
        String url = call.arguments as String;
        _vscreen.add(url);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("on resumed");
        await _vscreen.reconnect();
        break;
      case AppLifecycleState.paused:
        print("on paused");
        await _vscreen.disconnect();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.suspending:
        break;
    }
  }

  Widget buildInfo(String url, String title, String thumbnail) {
    if (title.length > 30) {
      title = title.substring(0, 30) + "...";
    }
    final ImageProvider<dynamic> _thumbnail = thumbnail == ""
        ? AssetImage("assets/placeholders/thumbnail.jpg")
        : NetworkImage(thumbnail);

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _thumbnail,
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context, builder: (_) => ConnectionDialog());
                    },
                    child: Text(url == "" ? "connect" : url,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Center(
                      child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    spreadRadius: 0.2,
                                    blurRadius: 30.0)
                              ],
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: _thumbnail)))),
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ])),
          ),
        ));
  }

  Widget buildControllerButton(
      IconData icon, double size, VoidCallback onPressed) {
    double padding = 20;
    return Container(
        width: size,
        height: size,
        child: new RawMaterialButton(
          shape: new CircleBorder(),
          fillColor: Colors.white,
          elevation: 0.0,
          child: new Icon(icon, color: Colors.black, size: size - padding),
          onPressed: onPressed,
        ));
  }

  Widget buildController(bool playing) {
    Widget middleButton;
    if (playing) {
      middleButton = buildControllerButton(Icons.pause, 70, () {
        _vscreen.pause();
      });
    } else {
      middleButton = buildControllerButton(Icons.play_arrow, 70, () {
        _vscreen.play();
      });
    }

    Widget leftButton = buildControllerButton(Icons.stop, 45, () {
      _vscreen.stop();
    });

    Widget rightButton = buildControllerButton(Icons.skip_next, 45, () {
      _vscreen.next();
    });

    return Container(
        color: Colors.blueGrey[900],
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[leftButton, middleButton, rightButton],
        ));
  }

  @override
  Widget build(BuildContext context) {
    _vscreen = VScreen.of(context).bloc;

    return StreamBuilder<v.ConnectionState>(
        stream: _vscreen.connection.where((state) => !(state is v.Connecting)),
        initialData: v.Disconnected(),
        builder: (context, snapshot) {
          var url = "";
          if (snapshot.hasError) {
          } else {
            var state = snapshot.data;
            if (state is v.Connected) {
              url = state.url;
            }
          }

          return StreamBuilder<v.PlayerState>(
              stream: _vscreen.player,
              initialData: v.NewPlayerInfo(),
              builder: (context, snapshot) {
                var info = snapshot.data as v.NewPlayerInfo;

                return Scaffold(
                    backgroundColor: Colors.white,
                    body: Column(
                      children: <Widget>[
                        Expanded(
                            flex: 5,
                            child: buildInfo(url, info.title, info.thumbnail)),
                        Slider(
                          value: info.position,
                          onChanged: (_) {},
                          onChangeEnd: (value) {
                            print(value);
                            _vscreen.seek(value);
                          },
                          min: 0.0,
                          max: 1.0,
                        ),
                        Expanded(flex: 1, child: buildController(info.playing))
                      ],
                    ));
              });
        });
  }
}
