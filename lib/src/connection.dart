part of '../pusher_client_ego.dart';

class PusherConnection {
  WebSocket? _socket;
  final String appKey;
  final String cluster;
  final void Function(String, dynamic) onEvent;
  late String socketId;

  StreamSubscription? _eventSubscription;
  StreamController streamController;

  PusherConnection({
    required this.appKey,
    required this.cluster,
    required this.onEvent,
    required this.streamController,
  });

  Future<void> connect() async {
    final url =
        'wss://ws-$cluster.pusher.com/app/$appKey?protocol=7&client=flutter&version=1.0';
    _socket = await WebSocket.connect(url);

    final completer = Completer<void>();

    _eventSubscription = _socket?.listen(
      (event) {
        final decoded = jsonDecode(event);
        if (decoded['event'] == 'pusher:connection_established') {
          final payload = jsonDecode(decoded['data']);
          socketId = payload['socket_id'];
          completer.complete();
        }
        streamController.add(decoded);
        onEvent(decoded['event'], decoded);
      },
      onError: (error) {
        completer.completeError(error);
      },
    );

    await completer.future;
  }

  void send(dynamic data) {
    _socket?.add(jsonEncode(data));
  }

  void disconnect() {
    streamController.close();
    _eventSubscription?.cancel();
    _socket?.close();
    _socket = null;
  }
}
