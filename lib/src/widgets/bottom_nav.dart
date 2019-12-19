import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function onClick;

  const BottomNav({Key key, @required this.currentIndex, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: new Icon(Icons.home),
        title: new Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.mail),
        title: new Text('Messages'),
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.mail),
        title: new Text('Another'),
      ),
      BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Profile'))
    ];

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (onClick != null) {
          onClick(index);
        }
      },
      type: BottomNavigationBarType.fixed,
      items: items,
    );
  }
}
