import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AudioPlayer audioPlayer = AudioPlayer();

class Sermons extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    audioPlayer.play(
        "https://firebasestorage.googleapis.com/v0/b/cornerstone-47d33.appspot.com/o/1.mp3?alt=media&token=1275d5d5-3c62-41bc-a208-8b67ba86ce4e"
    );
    return FutureBuilder<Object>(
      future: audioPlayer.play(
          "https://firebasestorage.googleapis.com/v0/b/cornerstone-47d33.appspot.com/o/1.mp3?alt=media&token=1275d5d5-3c62-41bc-a208-8b67ba86ce4e"
      ),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(child: Text("Has Not Started"),);
        }
        if(snapshot.data != 1){
          return Center(child: Text("Not successfull"),);
        }
        return Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .05),
          child: StreamBuilder<AudioPlayerState>(
              stream: audioPlayer.onNotificationPlayerStateChanged,
              builder: (context, snapshot){
                return Text(snapshot?.data?.toString() ??"0");
            },
          ),
        );
      }
    );
  }
}
