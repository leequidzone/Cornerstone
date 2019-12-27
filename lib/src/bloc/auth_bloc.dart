import 'dart:async';

import 'package:church/collection.dart';
import 'package:church/firebase_service.dart';
import 'package:church/src/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthBloc {
  static final String onBoardDateKeyMilli = "onBoardDate";
  static final String signUpDateEpochMilliSeconds =
      "signUpDateEpochMilliSeconds";
  static final String signUpDate = "signUpDate";

  final FireBaseService fireBaseService;

  final StreamController<bool> _authController = StreamController.broadcast();
  final StreamController<bool> _authBlocking = StreamController.broadcast();
  final StreamController<bool> _emailReset = StreamController.broadcast();
  final StreamController<String> _onError = StreamController.broadcast();
  final StreamController<bool> _enableSubmit = StreamController.broadcast();

  Stream<bool> get enableSubmit => _enableSubmit.stream;

  Stream<bool> get emailReset => _emailReset.stream;

  Stream<bool> get onAuthChange => _authController.stream;

  Stream<bool> get onBlockingChange => _authBlocking.stream;

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
  }

  Future<FirebaseUser> fbUser() async {
    return await _auth.currentUser();
  }

  void signOut() {
    _auth.signOut();
  }

  void validate(List<String> s) async {
    int validField = 0;
    s.forEach((str){
      if(str != null && str.isNotEmpty){
        validField++;
      }
    });
    if (validField == 9) {
      _enableSubmit.add(true);
    } else {
      _enableSubmit.add(false);
    }
  }

  void resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
    _emailReset.add(true);
  }

  void _storeUserData(AuthResult result, DateTime date, User userModel) async {
    date = date ?? DateTime.now();
    if (result?.user != null) {
      final store = fireBaseService.fireStore;
      FirebaseUser user = result.user;
      CollectionReference col = store.collection(Collection.users.toString());
      DocumentReference docRef = col.document(user.uid);
      await docRef.setData(userModel.toJson(), merge: true).then((_) {
        print("User Created ${userModel.toJson()}");
        store
            .collection("roles")
            .document(user.uid)
            .setData(<String, dynamic>{"role": "basic"});
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

  void onSignIn(String email, String password) async {
    _authBlocking.add(false);
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      _errorHandler(_onError, null, e: e as PlatformException);
    }
    _authBlocking.add(false);
  }

  void onSignUp(String email, String password,
      {String firstName,
      String lastName,
      String address,
      String address1,
      String city,
      String state,
      String zip,
      String dob}) async {
    _authBlocking.add(true);
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = User(
        uid: result.user.uid,
        firstName: firstName,
        lastName: lastName,
        address: address,
        address1: address1,
        city: city,
        state: state,
        zip: zip,
        dob: dob,
      );
      await _storeUserData(result, DateTime.now(), user);
    } catch (e) {
      _onError.add(e.toString());
    }
    _authBlocking.add(false);
  }
}
