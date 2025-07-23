import 'dart:convert';
import 'package:app/config/constants/app_constants.dart';
import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';

typedef OnDeltaReceived = void Function(Delta delta);
typedef OnConnectionStatusChanged = void Function(bool isConnected);

class WebSocketService {
  late WebSocketChannel _channel;
  late String _documentId;
  OnDeltaReceived? onDelta;
  OnConnectionStatusChanged? onConnectionStatusChanged;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> connect(String documentId) async {
    try {
      _documentId = documentId;
      // Match your Go server endpoint - remove the documentId from URL
      final uri = Uri.parse(
        '${AppConstants.APP_URL}/ws/$_documentId',
      ).replace(scheme: 'ws');
      final url = uri.toString();
      _channel = HtmlWebSocketChannel.connect(url);
      await _channel.ready;

      _isConnected = true;
      onConnectionStatusChanged?.call(true);
      print('WebSocket connected successfully');

      // Listen to incoming messages
      _channel.stream.listen(
        _onMessageReceived,
        onDone: () {
          _isConnected = false;
          onConnectionStatusChanged?.call(false);
          print('WebSocket connection closed');
        },
        onError: (error) {
          _isConnected = false;
          onConnectionStatusChanged?.call(false);
          print('WebSocket error: $error');
        },
      );

      // Send join message after connection
      _sendJoin();
    } catch (e) {
      _isConnected = false;
      onConnectionStatusChanged?.call(false);
      print('Failed to connect to WebSocket: $e');
      rethrow;
    }
  }

  void _sendJoin() {
    if (!_isConnected) return;
    final joinMessage = {"event": "join", "room": _documentId};
    _channel.sink.add(jsonEncode(joinMessage));
    print('Sent join message for room: $_documentId');
  }

  void sendTyping(Delta delta) {
    if (!_isConnected) {
      print('Cannot send typing - not connected');
      return;
    }

    final message = {
      "event": "typing",
      "room": _documentId,
      "data": delta.toJson(),
    };
    _channel.sink.add(jsonEncode(message));
    print('Sent typing event with delta: ${delta.toJson()}');
  }

  void sendSave(Delta documentContent) {
    if (!_isConnected) {
      print('Cannot send save - not connected');
      return;
    }

    final message = {
      "event": "save",
      "room": _documentId,
      "data": documentContent.toJson(), // Include the full document content
    };
    _channel.sink.add(jsonEncode(message));
    print(
      'Sent save event for room: $_documentId with content: ${documentContent.toJson()}',
    );
  }

  void _onMessageReceived(dynamic message) {
    try {
      final decoded = jsonDecode(message);
      print('Received WebSocket message: $decoded');

      if (decoded['event'] == 'changes' && decoded['data'] != null) {
        final delta = Delta.fromJson(decoded['data']);
        print('Parsed delta from remote: ${delta.toJson()}');
        onDelta?.call(delta);
      }
    } catch (e) {
      print('Error parsing WebSocket message: $e');
    }
  }

  void disconnect() {
    if (_isConnected) {
      _channel.sink.close();
      _isConnected = false;
      onConnectionStatusChanged?.call(false);
      print('WebSocket disconnected');
    }
  }
}
