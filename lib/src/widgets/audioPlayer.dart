import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:church/src/models/sermon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocalAudioPlayer extends StatefulWidget {
  LocalAudioPlayer({this.sermon});

  final Sermon sermon;

  @override
  _LocalAudioState createState() => _LocalAudioState(sermon: this.sermon);
}

class _LocalAudioState extends State<LocalAudioPlayer> {
  _LocalAudioState({this.sermon});

  final Sermon sermon;
  Duration _duration = Duration();
  Duration _position = Duration();
  AudioPlayer advancedPlayer;
  String filePath;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.stop().then((int) {
      advancedPlayer.dispose();
    });
  }

  void initPlayer() {
      advancedPlayer = AudioPlayer();

      advancedPlayer.onDurationChanged.listen((Duration d) {
        setState(() {
          _duration = d;
        });
      });

      advancedPlayer.onAudioPositionChanged.listen((Duration p) {
        setState(() {
          _position = p;
        });
      });
  }

  Widget _tab(List<Widget> children) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: children);
  }

  Widget _btn(String txt, VoidCallback onPressed) {
    return ButtonTheme(
      minWidth: 48.0,
      child: Container(
        width: 50,
        height: 45,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Text(txt),
          color: Colors.pink[900],
          textColor: Colors.white,
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget slider() {
    return Slider(
      activeColor: Colors.black,
      inactiveColor: Colors.pink,
      value: _position.inSeconds.toDouble(),
      min: 0.0,
      max: _duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          seekToSecond(value.toInt());
          value = value;
        });
      },
    );
  }

  Widget localAudio() {
    return Column(children: [
      _tab([
        _btn('Play', () => advancedPlayer.play(this.sermon.path)),
        _btn('Pause', () => advancedPlayer.pause()),
        _btn('Stop', () => advancedPlayer.stop()),
      ]),
      slider()
    ]);
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1.0,
          backgroundColor: Colors.teal,
          title: Text(this.sermon.title),
        ),
        body: TabBarView(
          children: <Widget>[localAudio()],
        ),
      ),
    );
  }
}
