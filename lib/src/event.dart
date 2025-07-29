part of '../pusher_client_ego.dart';

class PusherEvent {
  final String event;
  final dynamic data;

  PusherEvent({required this.event, required this.data});

  factory PusherEvent.fromJson(Map<String, dynamic> json) {
    return PusherEvent(
      event: json['event'],
      data: jsonDecode(json['data'] ?? '{}'),
    );
  }
}
