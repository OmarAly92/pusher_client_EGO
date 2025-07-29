part of '../pusher_client.dart';

typedef EventCallback = void Function(PusherEvent event);

class PusherChannel {
  final String name;
  final PusherConnection connection;
  final Map<String, List<EventCallback>> _eventBindings = {};

  PusherChannel(this.name, this.connection);

  void bind(String eventName, EventCallback callback) {
    _eventBindings.putIfAbsent(eventName, () => []).add(callback);
  }

  void handleEvent(PusherEvent event) {
    if (_eventBindings.containsKey(event.event)) {
      for (final cb in _eventBindings[event.event]!) {
        cb(event);
      }
    }
  }

  void trigger(String event, dynamic data) {
    connection.send({
      'event': 'client-$event',
      'data': jsonEncode(data),
      'channel': name,
    });
  }
}
