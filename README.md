# 📡 PusherClient

A lightweight Flutter package that brings [Pusher Channels](https://pusher.com/channels) real-time functionality to Flutter apps, inspired by the official [pusher-js](https://github.com/pusher/pusher-js) library.

---

## 🚀 Features

- ✅ Connect to Pusher via WebSocket
- 📢 Subscribe to public, private, and presence channels
- 📬 Bind to custom and system events
- 🔐 Support for authenticated channels
- 🔄 Auto-handles `pusher:connection_established`, `subscription_succeeded`, etc.
- 🔄 Trigger client events on private channels (e.g., `client-typing`)
- 🧑‍🤝‍🧑 Presence channels with user tracking

---

## 📦 Installation

  ```yaml
dependencies:
  pusher_client:
    git:
      url: https://github.com/yourusername/pusher_client.git
  ```

---

## 🛠️ Getting Started

### 1. Import and initialize

  ```dart
  import 'package:pusher_client/pusher_client.dart';
  
  final pusher = PusherClient(
key: 'YOUR_PUSHER_KEY',
cluster: 'YOUR_CLUSTER',
authEndpoint: 'https://yourserver.com/pusher/auth', // Optional
headers: {
  'Authorization': 'Bearer YOUR_TOKEN', // Optional
},
  );
  
  await pusher.connect();
  ```

---

### 2. Subscribe to a channel

  ```dart
  final channel = pusher.subscribe('public-chat');
  
  channel.bind('new-message', (event) {
print('📩 Message: ${event.data}');
});
  ```

---

### 3. Trigger a client event (private channels only)

```dart
final privateChannel = pusher.subscribe('private-room');

```

---

### 🔐 Auth for Private & Presence Channels

Your backend must return a JSON object like this:

#### For Private Channels:

  ```json
  {
    "auth": "your_app_key:signature"
  }
  ```

#### For Presence Channels:

  ```json
  {
    "auth": "your_app_key:signature",
    "channel_data": "{\"user_id\": \"123\", \"user_info\": {\"name\": \"Alice\"}}"
  }
  ```

Use Pusher's official server SDKs to generate these responses:
- [Node.js](https://github.com/pusher/pusher-http-node)
- [PHP](https://github.com/pusher/pusher-http-php)
- [Python](https://github.com/pusher/pusher-http-python)

---

## 🧪 Example `main.dart`

  ```dart
  void main() async {
  final pusher = PusherClient(
key: 'APP_KEY',
cluster: 'APP_CLUSTER',
authEndpoint: 'https://your-auth-endpoint',
  );

  await pusher.connect();

  final channel = pusher.subscribe('public-chat');
  channel.bind('new-message', (event) {
print('Received: ${event.data}');
});

await Future.delayed(Duration(days: 365)); // Keep alive
}
  ```

---

## 📚 API Reference

| Method                  | Description                             |
  |-------------------------|-----------------------------------------|
| `connect()`             | Establishes the WebSocket connection    |
| `subscribe(channel)`    | Subscribes to a channel                 |
| `bind(event, handler)`  | Binds a callback to a given event       |
| `trigger(event, data)`  | Sends a client event (private only)     |

---

## ⚠️ Limitations

- This is a simplified version and doesn't include encryption or full presence features like member lists yet.
- Ensure your auth server signs correctly for private/presence channels.

---

## 📃 License

MIT © Your Name

---

## 🙌 Acknowledgments

Inspired by the official [pusher-js](https://github.com/pusher/pusher-js) and [pusher-http](https://github.com/pusher) libraries.
