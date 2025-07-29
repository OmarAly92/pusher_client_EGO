part of '../pusher_client.dart';

class PusherClient {
  final String key;
  final String cluster;
  final String? authEndpoint;
  final Map<String, String> headers;
  final String? bindEvent;

  late final PusherConnection _connection;
  final Map<String, PusherChannel> _channels = {};
  PusherAuthorizer? _authorizer;

  PusherClient({
    required this.key,
    required this.cluster,
    this.authEndpoint,
    this.bindEvent,
    this.headers = const {},
  }) {
    _connection = PusherConnection(
      appKey: key,
      cluster: cluster,
      onEvent: _handleEvent,
      streamController: StreamController(),
      bindEvent: bindEvent,
    );

    if (authEndpoint != null) {
      _authorizer = PusherAuthorizer(
        authEndpoint: authEndpoint!,
        headers: headers,
      );
    }
  }

  Future<void> connect() => _connection.connect();

  PusherChannel subscribe(String channelName) {
    final channel = PusherChannel(channelName, _connection);
    _channels[channelName] = channel;

    if (_isPrivate(channelName) && _authorizer != null) {
      _authorizer!.authorize(channelName, _connection.socketId).then((auth) {
        _connection.send({
          'event': 'pusher:subscribe',
          'data': {
            'channel': channelName,
            'auth': auth['auth'],
            if (auth.containsKey('channel_data'))
              'channel_data': auth['channel_data'],
          },
        });
      });
    } else {
      _connection.send({
        'event': 'pusher:subscribe',
        'data': {'channel': channelName},
      });
    }
    return channel;
  }

  void _handleEvent(String event, dynamic raw) {
    if (raw['channel'] != null && _channels.containsKey(raw['channel'])) {
      final evt = PusherEvent.fromJson(raw);
      _channels[raw['channel']]?.handleEvent(evt);
    }
  }

  bool _isPrivate(String channel) =>
      channel.startsWith('private-') || channel.startsWith('presence-');

  void disconnect() {
    _connection.disconnect();
    _channels.clear();
  }
}
