import 'package:flutter/material.dart';
import 'info.dart';
import 'controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vscreen_client_core/vscreen_client_core.dart' as vscreen;

class PlayerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final _connectionBloc = vscreen.VScreenBloc().connection;
  final _playerBloc = vscreen.VScreenBloc().player;

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
                        flex: 1,
                        child: ControllerWidget(
                          playing: playerState.playing,
                        ))
                  ],
                ));
          },
        );
      },
    );
  }
}
