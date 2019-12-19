//AutoGenerated:
import 'package:flutter/material.dart';
import '../models/fire_user.dart';

class FireUserListItemWidget extends StatelessWidget {
  final FireUser fireUser;
  FireUserListItemWidget(this.fireUser);
  @override
  Widget build(context) {
    assert(fireUser != null);
//TODO
    print('complete FireUserListItemWidget');
    return Container(child: Text('FireUserListItemWidget'));
  }
}

class FireUserListWidget extends StatelessWidget {
  final List<FireUser> fireUsers;
  FireUserListWidget(this.fireUsers);
  @override
  Widget build(context) {
    return ListView.builder(
        itemCount: this.fireUsers.length,
        itemBuilder: (BuildContext context, int index) {
          return FireUserListItemWidget(this.fireUsers[index]);
        });
  }
}
