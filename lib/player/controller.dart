import 'package:flutter/material.dart';
import 'package:vscreen_client_core/vscreen_client_core.dart';

class ControllerWidget extends StatelessWidget {
  final bool _playing;
  final _playerBloc = VScreenBloc().player;

  ControllerWidget({playing = false}) : _playing = playing;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blueGrey[900],
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
            ),
            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                _playerBloc.dispatch(_playing ? Pause() : Play());
              },
              child: Icon(_playing ? Icons.pause : Icons.play_arrow,
                  color: Colors.black, size: 32),
            ),
            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {},
              child: Icon(Icons.skip_next, color: Colors.black),
              mini: true,
            )
          ],
        ));
  }
}
