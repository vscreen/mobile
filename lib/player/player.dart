import 'package:flutter/material.dart';
import 'info.dart';
import 'controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vscreen_client_core/vscreen_client_core.dart';

class PlayerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final _playerBloc = VScreenBloc().player;
  final _connectionBloc = VScreenBloc().connection;

  @override
  Widget build(BuildContext context) {
    _connectionBloc.dispatch(Connect(url: "192.168.0.24", port: 8080));

    return BlocBuilder<PlayerEvent, PlayerState>(
      bloc: _playerBloc,
      builder: (ctx, state) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                Expanded(
                    flex: 5,
                    child: InfoWidget(
                        title: state.title, thumbnail: state.thumbnail)),
                Expanded(
                    flex: 1,
                    child: ControllerWidget(
                      playing: state.playing,
                    ))
              ],
            ));
      },
    );
  }
}
