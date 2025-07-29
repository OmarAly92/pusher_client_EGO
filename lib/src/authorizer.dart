part of '../pusher_client.dart';

class PusherAuthorizer {
  final String authEndpoint;
  final Map<String, String> headers;

  PusherAuthorizer({required this.authEndpoint, this.headers = const {}});

  Future<Map<String, dynamic>> authorize(
    String channelName,
    String socketId,
  ) async {
    final response = await http.post(
      Uri.parse(authEndpoint),
      headers: headers,
      body: {'socket_id': socketId, 'channel_name': channelName},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Auth failed: ${response.body}');
    }
  }
}
