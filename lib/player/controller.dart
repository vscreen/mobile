import 'package:flutter/material.dart';

class ControllerWidget extends StatelessWidget {
  final bool _isPlaying;
  final VoidCallback onPlayToggle;

  ControllerWidget({isPlaying = false, this.onPlayToggle})
      : _isPlaying = isPlaying;

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
                onPlayToggle();
              },
              child: Icon(_isPlaying ? Icons.play_arrow : Icons.pause,
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
