import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseService {
  final FirebaseAuth _auth;
  final Firestore store;

  FireBaseService(FirebaseAuth fireBaseAuth, Firestore fireStore)
      : this._auth = fireBaseAuth ?? FirebaseAuth.instance,
        this.store = fireStore ?? Firestore.instance;

  FirebaseAuth get fireBaseAuth => _auth;

  Firestore get fireStore => store;
}
