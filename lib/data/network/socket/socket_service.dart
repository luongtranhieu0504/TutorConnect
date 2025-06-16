import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:rxdart/rxdart.dart';
import 'package:tutorconnect/config/app_config.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/domain/model/message.dart';

@singleton
class SocketService {
  IO.Socket? _socket;
  final _messageController = BehaviorSubject<Message>();
  final _connectedController = BehaviorSubject<bool>.seeded(false);
  int? _currentConversationId; // Add this to track the active conversation

  Stream<Message> get messageStream => _messageController.stream;
  Stream<bool> get connectedStream => _connectedController.stream;
  bool get isConnected => _connectedController.value;

  SocketService();

  void init() {
    final userId = Account.instance.user.id;

    _socket = IO.io(
      'https://backend-strapi-gh6q.onrender.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setQuery({'userId': userId.toString()})
          .build(),
    );

    _setupSocketListeners();
    connect();
  }

  void _setupSocketListeners() {
    if (_socket != null) {
      _socket!.on('connect', (_) {
        print('Socket connected');
        if (_currentConversationId != null) {
          print('Auto re-joining room: conversation_$_currentConversationId');
          _socket!.emit('join', _currentConversationId);
        }
        _connectedController.add(true);
      });

      _socket!.on('disconnect', (_) {
        print('Socket disconnected');
      });

      _socket!.on('message', (data) {
        print('Message received: $data');
        try {
          final message = Message.fromJson(data);
          _messageController.add(message);
          _connectedController.add(true);
        } catch (e) {
          print('Failed to parse message: $e');
        }
      });
    }
  }

  void connect() {
    if (_socket != null && !_socket!.connected) {
      _socket!.connect();
    }
  }

  void joinConversation(int conversationId) {
    _currentConversationId = conversationId; // Cập nhật mỗi lần join

    if (_socket == null) return;

    if (_socket!.connected) {
      print('Joining room: conversation_$conversationId');
      _socket!.emit('join', conversationId);
    } else {
      print('Waiting for connection to join room');
      _socket!.once('connect', (_) {
        print('Connected. Now joining room: conversation_$conversationId');
        _socket!.emit('join', conversationId);
      });
      connect();
    }
  }

  void sendMessage(int conversationId, Message message) {
    if (_socket == null || !_socket!.connected) {
      print('Socket not connected. Cannot send message');
      return;
    }

    print('Sending message via socket: ${message.content}');
    _socket!.emit('message', {
      'conversationId': conversationId,
      'message': message.toJson()
    });
  }

  void leaveConversation(int conversationId) {
    if (_socket != null && _socket!.connected) {
      print('Leaving conversation: $conversationId');
      if (_currentConversationId == conversationId) {
        _currentConversationId = null; // Clear the active conversation ID
      }
      _socket!.emit('leave_conversation', {'conversationId': conversationId});
    }
  }

  void disconnect() {
    if (_socket != null && _socket!.connected) {
      _socket!.disconnect();
    }
  }
}