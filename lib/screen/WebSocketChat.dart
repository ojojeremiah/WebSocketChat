import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:interview_test/service/AuthService.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketChat extends StatefulWidget {
  const WebSocketChat({super.key});

  @override
  State<WebSocketChat> createState() => _WebSocketChatState();
}

class _WebSocketChatState extends State<WebSocketChat> {
  AuthService authService = AuthService();
  late WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  String? jwtToken;

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
  }

  Future<void> _initializeWebSocket() async {
    jwtToken = await authService.getToken();
    if (jwtToken != null) {
      channel = WebSocketChannel.connect(
        Uri.parse('wss://your-api.com/ws/chat/?token=$jwtToken'),
      );
    }
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      channel.sink.add(jsonEncode({'question': message}));
    }
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? '${snapshot.data}' : '');
                },
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message'),
              onSubmitted: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
