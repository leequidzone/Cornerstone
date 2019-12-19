import 'package:flutter/material.dart';
import '../models/event.dart';

class EventListItemWidget extends StatelessWidget {
  final Event event;
  EventListItemWidget(this.event);
  @override
  Widget build(context) {
    assert(event != null);
//TODO
    print('complete EventListItemWidget');
    return Container(child: Text('EventListItemWidget'));
  }
}

class EventListWidget extends StatelessWidget {
  final List<Event> events;
  EventListWidget(this.events);
  @override
  Widget build(context) {
    return ListView.builder(
        itemCount: this.events.length,
        itemBuilder: (BuildContext context, int index) {
          return EventListItemWidget(this.events[index]);
        });
  }
}
