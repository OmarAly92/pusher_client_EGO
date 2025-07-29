part of '../pusher_client_ego.dart';

typedef EventCallback = void Function(dynamic event);

class PusherChannel {
  StreamSubscription? _subscription;
  final String name;
  final PusherConnection connection;
  final Map<String, List<EventCallback>> _eventBindings = {};

  PusherChannel(this.name, this.connection);

  void bind({
    String? eventName,
    required EventCallback success,
    EventCallback? error,
  }) {
    _subscription = connection.streamController.stream.listen((event) {
      if (eventName == null) {
        success(event);
        return;
      }
      if (event['event'] == eventName) {
        success(event);
      }
    }, onError: error);
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
