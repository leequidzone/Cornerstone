import 'package:church/src/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../factories.dart';

class Events extends StatelessWidget {
  final Factories _factories = Factories();
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _zip = TextEditingController();
  final TextEditingController _street = TextEditingController();
  final TextEditingController _startTime = TextEditingController();
  final format = DateFormat("MM-dd-yyyy HH:mm");

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
                        DateTime.fromMillisecondsSinceEpoch(event.startTime)) + '\n'
                    +DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(event.startTime))),
                  ],
                ),
                subtitle: Text(event.street + ' ' + event.city + ' ' + event.state + ' ' + event.zip),
                trailing: StreamBuilder<FirebaseUser>(
                    stream: _factories.authBloc.fbUser().asStream(),
                    builder: (context, user) {
                      return StreamBuilder<DocumentSnapshot>(
                          stream: Firestore.instance
                              .collection("events")
                              .document(event.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || user.data.uid == null) {
                              //Not Attending or no input
                              return IconButton(
                                  icon: Icon(Icons.done_outline,
                                      color: Colors.orange),
                                  iconSize: 30.0,
                                  onPressed: () => _factories.eventBloc
                                      .storeAttendanceStatus(
                                          user.data.uid,
                                          snapshot.data,
                                          !(snapshot.data ?? true)));
                            }
                            Event updatedEvent;
                            if(snapshot.data.data.isNotEmpty) {
                              updatedEvent = Event.fromJson(snapshot?.data?.data);
                            }
                            IconButton returnIconButton;
                            if (updatedEvent.attendance
                                    .containsKey(user?.data?.uid) &&
                                (updatedEvent?.attendance ?? Map())[user?.data?.uid ?? 0]) {
                              //Attending
                              returnIconButton = IconButton(
                                  icon: Icon(Icons.done_outline,
                                      color: Colors.green),
                                  iconSize: 30.0,
                                  onPressed: () => _factories.eventBloc
                                      .storeAttendanceStatus(
                                          user.data.uid, snapshot.data, false));
                            } else {
                              //Unattended
                              returnIconButton = IconButton(
                                  icon: Icon(Icons.done_outline,
                                      color: Colors.red),
                                  iconSize: 30.0,
                                  onPressed: () => _factories.eventBloc
                                      .storeAttendanceStatus(
                                          user.data.uid, snapshot.data, true));
                            }
                            return returnIconButton;
                          });
                    })),
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
              if (doc.data == null || doc.data.data == null
                  ? true
                  : doc.data.data['role'] == 'basic') {
                return Column();
              }
              return Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                        onTap: () => showCreateEventForm(context),
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

  void showCreateEventForm(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Create Event"),
                actions: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 16),
                      child: GestureDetector(
                          onTap: () async {
                            Firestore.instance
                                .collection("events")
                                .add(Event(
                                        attendance: Map<String, bool>(),
                                        street: _street.text,
                                        state: _state.text,
                                        zip: _zip.text,
                                        city: _city.text,
                                        eventName: _eventName.text,
                                        startTime: format
                                            .parse(_startTime.text)
                                            .toUtc()
                                            .millisecondsSinceEpoch)
                                    .toJson())
                                .then((d) {
                              Firestore.instance
                                  .collection("events")
                                  .document(d.documentID)
                                  .setData({"id": d.documentID}, merge: true);
                              _startTime.clear();
                              _eventName.clear();
                              _zip.clear();
                              _street.clear();
                              _state.clear();
                              _city.clear();
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
                    _startTime.clear();
                    _eventName.clear();
                    _zip.clear();
                    _street.clear();
                    _state.clear();
                    _city.clear();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 6),
                      child: Icon(Icons.arrow_back)),
                ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(10.0),
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 5,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "Event name "),
                      controller: _eventName,
                    ),
                    Container(
                      height: 5,
                    ),
                    DateTimeField(
                      decoration:
                          InputDecoration(labelText: "Event start time"),
                      format: format,
                      controller: _startTime,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                    ),
                    Container(
                      height: 5,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "Street "),
                      controller: _street,
                    ),
                    Container(
                      height: 5,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "City "),
                      controller: _city,
                    ),
                    Container(
                      height: 5,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "State "),
                      controller: _state,
                    ),
                    Container(
                      height: 5,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "Zip "),
                      controller: _zip,
                    ),
                  ],
                ),
              ));
        },
        fullscreenDialog: true));
  }
}
