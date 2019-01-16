import 'package:flutter/material.dart';
import 'info.dart';
import 'controller.dart';

class PlayerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(flex: 5, child: InfoWidget()),
            Expanded(
                flex: 1,
                child: ControllerWidget(
                  isPlaying: _isPlaying,
                  onPlayToggle: togglePlay,
                ))
          ],
        ));
  }

  togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }
}
