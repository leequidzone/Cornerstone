import 'dart:async';
import 'dart:convert';

import 'package:church/collection.dart';
import 'package:church/factories.dart';
import 'package:church/firebase_service.dart';
import 'package:church/src/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthBloc {
  static bool _enabled;
  static final String onBoardDateKeyMilli = "onBoardDate";
  static final String signUpDateEpochMilliSeconds =
      "signUpDateEpochMilliSeconds";
  static final String signUpDate = "signUpDate";

  final FireBaseService fireBaseService;

  final StreamController<bool> _authController = StreamController.broadcast();
  final StreamController<bool> _authBlocking = StreamController.broadcast();
  final StreamController<bool> _emailReset = StreamController.broadcast();
  final StreamController<String> _onError = StreamController.broadcast();
  final StreamController<bool> _onBoarded = StreamController.broadcast();
  final StreamController<bool> _enableSubmit = StreamController.broadcast();


  Stream<bool> get emailReset => _emailReset.stream;

  Stream<bool> get onAuthChange => _authController.stream;

  Stream<bool> get onBlockingChange => _authBlocking.stream;

  Stream<bool> get enableSubmit => _enableSubmit.stream;

  Stream<String> get error => _onError.stream;

  FirebaseAuth get _auth => fireBaseService.fireBaseAuth;

  AuthBloc(this.fireBaseService) {
    this.fireBaseService.fireBaseAuth.onAuthStateChanged.listen((f) {
      if (f != null) {
        _authController.add(true);
      } else {
        _authController.add(false);
      }
    });

    enableSubmit.listen((b) => _enabled = b);
  }

  Stream<bool> get onBoardStream => _onBoarded.stream;

  Future<FirebaseUser> fbUser() async {
    return await _auth.currentUser();
  }

  void onSubmit(String email, String pw) =>
      _enabled == false ? null : _onSubmit(email, pw);

  void _onSubmit(String email, String pw) {
    signInOrUp(email,pw);
  }

  void signOut() {
    _auth.signOut();
  }

  void resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
    _emailReset.add(true);
  }

  void signInOrUp(String email, String password,
      {DateTime time}) async {
    _authBlocking.add(true);
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _storeUserData(result, time ?? DateTime.now(), userData: null);
    } catch (e) {
      if (e.runtimeType == PlatformException) {
        PlatformException pe = e as PlatformException;
        if (isEqual(pe.code, AuthError.ERROR_EMAIL_ALREADY_IN_USE)) {
          try {
            await _auth.signInWithEmailAndPassword(
              email: email,
              password: password,
            );
          } catch (e) {
            _errorHandler(_onError, null, e: e as PlatformException);
          }
        } else {
          _errorHandler(_onError, null, e: e as PlatformException);
        }
      } else {
        _onError.add(e.toString());
      }
    }
    _authBlocking.add(false);
  }

  Future<void> _isOnBoarded() async {
    FirebaseUser user = await _auth.currentUser();
    String id = user?.uid;
    final store = fireBaseService.fireStore;
    CollectionReference col = store.collection(Collection.users.toString());
    DocumentReference docRef = col.document(id);
    docRef
        .snapshots()
        .listen((result) => _onBoarded.add(_onBoardedFrom(result)));
  }

  bool _onBoardedFrom(DocumentSnapshot result) {
    Map<String, dynamic> data = result.data;
    if (data == null) {
      return false;
    }
    DateTime createdDate = DateTime.fromMillisecondsSinceEpoch(
        (data[signUpDateEpochMilliSeconds] ?? 0) as int);
    DateTime onBoardedDate = DateTime.fromMillisecondsSinceEpoch(
        (data[onBoardDateKeyMilli] ?? 0) as int);
    int difference = (DateTime.now().toUtc().difference(createdDate).inDays);
    if (difference.abs() < 9 && onBoardedDate == null) {
      return false;
    }
    if (onBoardedDate == null) {
      return false;
    }
    return true;
  }

  void onBoardComplete(DateTime time) async {
    FirebaseUser user = await _auth.currentUser();
    String id = user.uid;
    final store = fireBaseService.fireStore;
    CollectionReference col = store.collection(Collection.users.toString());
    DocumentReference docRef = col.document(id);
    await docRef.setData(<String, dynamic>{
      onBoardDateKeyMilli: time.toUtc().millisecondsSinceEpoch
    }, merge: true);
  }

  void _storeUserData(AuthResult result, DateTime date,
      {Profile userData}) async {
    date = date ?? DateTime.now();
    if (result?.user != null) {
      final store = fireBaseService.fireStore;
      FirebaseUser user = result.user;
      CollectionReference col = store.collection(Collection.users.toString());
      DocumentReference docRef = col.document(user.uid);
      AdditionalUserInfo addInfo = result?.additionalUserInfo;
      Map<String, dynamic> profileMap = addInfo?.profile ?? <String, dynamic>{};
      String profileStr = jsonEncode(profileMap);
      Profile userModel = Profile();
      await docRef.setData(userModel.toJson(), merge: true).then((_) {
        print("User Created ${userModel.toJson()}");
      }).catchError((dynamic e) => print("Error: $e"));
    }
  }

  void _errorHandler(StreamController<dynamic> s, AuthResult result,
      {PlatformException e}) {
    if (e != null) {
      s.add(e.code
          .replaceAll("ERROR", "")
          .toLowerCase()
          .replaceAll("_", " ")
          .trim());
    } else {
      if (result?.user == null) {
        s.add("Unable to Authenticate");
      }
    }
  }
}
