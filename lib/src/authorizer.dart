part of '../pusher_client_ego.dart';

class PusherAuthorizer {
  final String authEndpoint;
  final Map<String, String> headers;
  final Dio dio;

  PusherAuthorizer({
    required this.dio,
    required this.authEndpoint,
    this.headers = const {},
  });

  Future<Map<String, dynamic>> authorize(
    String channelName,
    String socketId,
  ) async {
    final response = await dio.post(
      authEndpoint,
      options: Options(headers: headers),
      data: {'socket_id': socketId, 'channel_name': channelName},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Auth failed: ${response.data}');
    }
  }
}
