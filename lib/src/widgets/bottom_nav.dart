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
        icon: new Icon(Icons.announcement),
        title: new Text('Announcement'),
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.event),
        title: new Text('Events'),
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.mic),
        title: new Text('Sermons'),
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.info_outline),
          title: Text('About')
      )
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
