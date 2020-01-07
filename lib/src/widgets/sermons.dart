import 'package:audioplayers/audioplayers.dart';
import 'package:church/src/models/sermon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Sermons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .05),
      child: createSermonButton(context),
    );
  }

  Widget createSermonButton(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("sermons")
            .orderBy('date', descending: true)
            .limit(4)
            .snapshots(),
        builder: (context, snapshot) {
          return ListView(
              children: <Widget>[...sermons(context, snapshot.data)]);
        });
  }
}

List<Widget> sermons(BuildContext context, QuerySnapshot snapshot) {
  if (snapshot == null) {
    return [CircularProgressIndicator()];
  }
  return snapshot?.documents?.map((DocumentSnapshot i) {
    Map<String, dynamic> map = i.data;
    Sermon sermon = Sermon.fromJson(map);
    return Column(
      children: <Widget>[
        Container(
          child: ListTile(
              title: Row(
                children: <Widget>[
                  Text(sermon.title),
                  Spacer(),
                  Text(sermon.date)
                ],
              ),
              subtitle: Text(sermon.verse)),
        )
      ],
    );
  })?.toList();
}
