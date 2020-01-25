import 'package:church/firebase_service.dart';
import 'package:church/src/bloc/auth_bloc.dart';
import 'package:church/src/bloc/event_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Factories {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static Firestore _firestore = Firestore.instance;
  static FireBaseService _fireBaseService = FireBaseService(_auth, _firestore);
  static AuthBloc _authBloc = AuthBloc(_fireBaseService);
  static EventBloc _eventBloc = EventBloc(_fireBaseService);

  EventBloc get eventBloc => _eventBloc;

  AuthBloc get authBloc => _authBloc;

  FireBaseService get fireBaseService => _fireBaseService;


}

bool isEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email ?? "");
}

bool isPassword(String password) {
  return (password?.trim()?.length ?? 0) > 6;
}

