import 'package:flutter/material.dart';
import 'dart:ui';

String truncate(String str, int length) {
  if (str.length < length) return str;
  return str.substring(0, length) + "...";
}

class InfoWidget extends StatelessWidget {
  final ImageProvider<dynamic> _thumbnail;
  final String _title;

  InfoWidget({title = "", thumbnail = ""})
      : _title = truncate(title, 30),
        _thumbnail = thumbnail == ""
            ? AssetImage("assets/placeholders/thumbnail.jpg")
            : NetworkImage(thumbnail);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: this._thumbnail,
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
          ),
        ),
        SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
              Text('Connected to ...',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                              fit: BoxFit.cover, image: this._thumbnail)))),
              Text(
                _title,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ]))
      ],
    );
  }
}
