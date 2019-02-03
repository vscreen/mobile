import 'package:flutter/material.dart';
import 'info.dart';
import 'controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:vscreen_client_core/vscreen_client_core.dart' as vscreen;

class PlayerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  static const _platform = const MethodChannel('app.channel.shared.data');
  final _connectionBloc = vscreen.VScreenBloc().connection;
  final _playerBloc = vscreen.VScreenBloc().player;

  _PlayerWidgetState() {
    _platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == "getSharedURL") {
        String url = call.arguments as String;
        _playerBloc.dispatch(vscreen.Add(url));
      }
    });
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
        _playerBloc.dispatch(vscreen.Pause());
      });
    } else {
      middleButton = buildControllerButton(Icons.play_arrow, 70, () {
        _playerBloc.dispatch(vscreen.Play());
      });
    }

    Widget leftButton = buildControllerButton(Icons.stop, 45, () {
      _playerBloc.dispatch(vscreen.Stop());
    });

    Widget rightButton = buildControllerButton(Icons.skip_next, 45, () {
      _playerBloc.dispatch(vscreen.Next());
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
    return BlocBuilder<vscreen.ConnectionEvent, vscreen.ConnectionState>(
      bloc: _connectionBloc,
      builder: (_, connectionState) {
        return BlocBuilder<vscreen.PlayerEvent, vscreen.PlayerState>(
          bloc: _playerBloc,
          builder: (_, playerState) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  children: <Widget>[
                    Expanded(
                        flex: 5,
                        child: InfoWidget(
                            url: connectionState.url,
                            title: playerState.title,
                            thumbnail: playerState.thumbnail)),
                    Expanded(
                        flex: 1, child: buildController(playerState.playing))
                  ],
                ));
          },
        );
      },
    );
  }
}
