import 'dart:async';

import 'package:church/factories.dart';
import 'package:church/src/screens/auth_screen.dart';
import 'package:church/src/screens/user_screen.dart';
import 'package:church/src/widgets/bottom_nav.dart';
import 'package:church/src/widgets/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  return runApp(FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot?.data != null) {
            return MaterialApp(
              home: ChurchApp(),
            );
          }
          return MaterialApp(
            home: AuthScreen(factories: Factories()),
          );
        });
  }
}

class ChurchAppBloc {

  StreamController<int> _onPageChange = StreamController.broadcast();
  Stream<int> get onPageChange => _onPageChange.stream;

  void addListener(PageController pageController){
    _onPageChange.add(pageController.page.ceil());
  }
}

class ChurchApp extends StatelessWidget {
  final PageController _pageController = PageController();
  final ChurchAppBloc _churchAppBloc = ChurchAppBloc();
  @override
  Widget build(BuildContext context) {
    _pageController.addListener((){
      _churchAppBloc.addListener(_pageController);
    });
    List<Widget> items = [Home(),Home(),Home()];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          GestureDetector(
            onTap: FirebaseAuth.instance.signOut,
            child: Container(
                margin: EdgeInsets.only(top: 8),
                child: Text("Logout", style: TextStyle(color: Colors.black),)),
          )
        ],
      ),
      body: PageView.builder(
        itemCount: items.length,
        controller: _pageController,
        itemBuilder: (context, index){
          return items[index];
        },
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: _churchAppBloc.onPageChange,
        builder: (context, snapshot) {
          return BottomNav(
            onClick: (index) {
              _pageController.jumpToPage(index);
            },

            currentIndex:snapshot.data??0,);
        }
      ),
    );
  }

}
