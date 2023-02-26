import 'dart:async';
import 'dart:collection';
import 'dart:developer' as dev;
import 'dart:typed_data' as td;

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart' as ws;

import 'variables.dart';

/// Transport
@internal
class Transport {
  /// Client
  factory Transport() => _internalSingleton;
  static final Transport _internalSingleton = Transport._internal();
  Transport._internal() {
    Timer.periodic(Duration(seconds: 5), (_) => _send());
  }

  /// Send queue
  final Queue<td.Uint8List> _queue = Queue<td.Uint8List>();

  /// Connection
  final Connection _connection = Connection();

  /// Sends bytes to the server
  void send(td.Uint8List bytes) {
    if (bytes.isEmpty) return;
    _queue.add(bytes);
    _send();
  }

  bool _$sending = false;
  Future<void> _send() async {
    try {
      if (_$sending || _queue.isEmpty || !_connection.isConnected) return;
      _$sending = true;
      while (_queue.isNotEmpty && _connection.isConnected) {
        final bytes = _queue.first;
        await _connection.push(bytes);
        _queue.removeFirst();
      }
    } on Object {
      _connection.close();
      // ignore
    } finally {
      _$sending = false;
    }
  }
}

/// Connection
@internal
class Connection {
  /// Connection
  Connection() {
    reconnect($uri);
    Timer.periodic(Duration(seconds: 15), (_) {
      if (isClosed) return reconnect($uri);
    });
  }

  ws.WebSocketChannel? _client;
  final StreamController<List<int>> _responsesController =
      StreamController<List<int>>.broadcast();

  StreamSubscription<Object?>? _subscription;
  ConnectionState _state = ConnectionState.closed;

  /// Responses
  late final Stream<List<int>> responses = _responsesController.stream;

  /// Connection established
  bool get isConnected => _state == ConnectionState.established;

  /// Connection closed
  bool get isClosed => _state == ConnectionState.closed;

  /// Connection in progress
  bool get inProgress => !isConnected && !isClosed;

  /// Pushes bytes to the server
  Future<void> push(td.Uint8List bytes) async {
    if (!isConnected) throw StateError('Connection is not established');
    final hash = sha1.convert(bytes).bytes;
    _client?.sink.add(bytes);
    await responses
        .where((event) {
          if (event.length != hash.length) return false;
          for (var i = 0; i < hash.length; i++) {
            if (event[i] != hash[i]) return false;
          }
          return true;
        })
        .first
        .timeout(Duration(seconds: 7));
  }

  /// Closes the connection
  Future<void> close() async {
    try {
      _state = ConnectionState.closing;
      _subscription?.cancel().ignore();
      _client?.sink.close(status.goingAway, 'RECONNECTING').ignore();
    } on Object {
      dev.debugger();
    } finally {
      _state = ConnectionState.closed;
    }
  }

  /// Reconnects to the server
  void reconnect(Uri? uri) => runZonedGuarded<void>(() async {
        switch (_state) {
          reconnect:
          case ConnectionState.closed:
            if (uri == null) return;
            _state = ConnectionState.establishing;
            final client = _client = ws.WebSocketChannel.connect(uri);
            _subscription = client.stream.listen(
              (data) {
                if (data is! List<int>) return;
                _responsesController.add(data);
              },
              cancelOnError: true,
            );
            await client.ready;
            _state = ConnectionState.established;
            break;
          case ConnectionState.establishing:
          case ConnectionState.closing:
            return; // Connection is in the process of establishing or closing
          case ConnectionState.established:
            close();
            continue reconnect;
        }
      }, (_, __) {
        close();
      });
}

/// Connection state
enum ConnectionState {
  /// The connection is not yet open or closed or couldn't be opened.
  closed,

  /// The connection is in the process of establishing.
  establishing,

  /// The connection is open and ready to communicate.
  established,

  /// The connection is in the process of closing.
  closing,
}
