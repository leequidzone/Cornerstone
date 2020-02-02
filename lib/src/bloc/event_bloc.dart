import 'dart:async';

import 'package:church/firebase_service.dart';
import 'package:church/src/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventBloc {
  final FireBaseService fireBaseService;

  final StreamController<bool> _attendance = StreamController.broadcast();

  Stream<bool> get onAttendanceChange => _attendance.stream;

  EventBloc(this.fireBaseService) {
    //Fetch init data
  }

  void storeAttendanceStatus(String userId,
      DocumentSnapshot eventSnapshot, bool attendance) async {
    Event event;
    event = Event.fromJson(eventSnapshot.data);
    final store = fireBaseService.fireStore;
    CollectionReference col = store.collection("events");
    DocumentReference docRef = col.document(event.id);
    Map<String, bool> attendanceMap = event.attendance;
    attendanceMap.putIfAbsent(userId, () => false);
    (attendanceMap ?? Map())[userId] = attendance;
    docRef.setData({"attendance": attendanceMap},merge: true);
  }
}
