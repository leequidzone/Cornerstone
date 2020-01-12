import 'package:church/src/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../factories.dart';

class Events extends StatelessWidget {
  final TextEditingController _anouncementController = TextEditingController();
  final Factories _factories = Factories();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .05),
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("events")
              .orderBy("startTime", descending: true)
              .limit(15)
              .snapshots(),
          builder: (context, snapshot) {
            return ListView(
              children: <Widget>[
                createPostButton(
                  context,
                ),
                ...events(context, snapshot.data),
              ],
            );
          }),
    );
  }

  List<Widget> events(BuildContext context, QuerySnapshot snapshot) {
    if (snapshot == null) {
      return [CircularProgressIndicator()];
    }
    return snapshot?.documents?.map((DocumentSnapshot i) {
      Map<String, dynamic> map = i.data;
      Event event = Event.fromJson(map);
      return Column(
        children: <Widget>[
          Container(
            child: ListTile(
                title: Row(
                  children: <Widget>[
                    Text(event.eventName),
                    Spacer(),
                    Text(DateFormat.yMd().format(
                        DateTime.fromMillisecondsSinceEpoch(
                            event.startTime))),
                  ],
                ),
              trailing: Icon(Icons.done_outline),
            ),
          ),
          Divider(),
        ],
      );
    })?.toList();
  }

  Widget createPostButton(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
        stream: _factories.authBloc.fbUser().asStream(),
        builder: (context, user) {
          return StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .document('roles/' + (user.data == null ? '1' : user.data.uid))
                .get()
                .asStream(),
            builder: (context, doc) {
              if (doc.data == null || doc.data.data == null ? true : doc.data.data['role'] == 'basic') {
                return Column();
              }
              return Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                        onTap: () => showCreateForm(context),
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            Text("Create Event"),
                            Icon(
                              Icons.add,
                              size: 20,
                            ),
                            Spacer(),
                          ],
                        )),
                  ),
                  Divider(),
                ],
              );
            },
          );
        });
  }

  void showCreateForm(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Announcements"),
                actions: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 16),
                      child: GestureDetector(
                          onTap: () async {
                            Firestore.instance
                                .collection("announcments")
                                .add(Event(
                                        uid: Uuid().v4(),
                                        startTime: DateTime.now()
                                            .toUtc()
                                            .millisecondsSinceEpoch)
                                    .toJson())
                                .then((d) {
                              _anouncementController.clear();
                              Navigator.of(context).pop();
                            });
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(fontSize: 20),
                          )))
                ],
                leading: GestureDetector(
                  onTap: () {
                    _anouncementController.clear();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 6),
                      child: Icon(Icons.arrow_back)),
                ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: TextField(
                        controller: _anouncementController,
                        decoration:
                            InputDecoration(hintText: "Type Announcement"),
                        minLines: null,
                        maxLines: null,
                        expands: true,
                      ),
                    )
                  ],
                ),
              ));
        },
        fullscreenDialog: true));
  }
}
