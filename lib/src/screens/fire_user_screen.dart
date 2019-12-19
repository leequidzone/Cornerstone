import 'package:church/src/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

class FireUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length:
            1, //This should be the same as the length of children in TabBarView
        child: Scaffold(
          bottomNavigationBar: BottomNav(currentIndex: 0,),
          body: TabBarView(
            children: [Container(child: Text('FireUserScreen'))],
          ),
          appBar: AppBar(
            bottom: TabBar(tabs: [Container(child: Text('FireUserScreen'))]),
            title: null,
            actions: <Widget>[Container(child: Text('FireUserScreen'))],
          ),
        ));
  }
}

class FireUserScreenToManyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length:
            1, //This should be the same as the length of children in TabBarView
        child: Scaffold(
          bottomNavigationBar: BottomNav(currentIndex: 0,),
          body: TabBarView(
            children: [Container(child: Text('FireUserScreen'))],
          ),
          appBar: AppBar(
            bottom: TabBar(tabs: [Container(child: Text('FireUserScreen'))]),
            title: null,
            actions: <Widget>[Container(child: Text('FireUserScreen'))],
          ),
        ));
  }
}
