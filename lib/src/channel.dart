part of '../pusher_client_ego.dart';

typedef EventCallback = void Function(dynamic event);

class PusherChannel {
  StreamSubscription? _subscription;
  final String name;
  final PusherConnection connection;
  final Map<String, List<EventCallback>> _eventBindings = {};

  PusherChannel(this.name, this.connection);

  void bind(String eventName, EventCallback callback) {
    _subscription = connection.streamController.stream.listen((event) {
      if (event['event'] == eventName) {
        callback(event);
      }
    });
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

  void close() {
    connection.send({
      'event': 'pusher:unsubscribe',
      'data': {'channel': name},
    });
    _subscription?.cancel();
  }
}
