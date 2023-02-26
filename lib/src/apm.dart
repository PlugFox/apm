// ignore_for_file: public_member_api_docs

import 'package:meta/meta.dart';

import 'capture.dart';
import 'log.dart';
import 'setup.dart';
import 'transaction.dart';

/// Application Performance Monitoring
@sealed
abstract class Monitoring {
  Monitoring._();

  /// Setup the application performance monitoring library.
  /// [project] is the project id. E.g. "my-project-1234"
  @pragma('vm:invisible')
  static void setup(
          {required String project, String uri = 'ws://localhost:38383'}) =>
      $setup(project: project, uri: uri);

  /// Capture [print]s from [body] and send them to [log] function.
  @pragma('vm:invisible')
  static R capture<R>(R Function() body) => $capture<R>(body);

  /// Runs [body] in a transaction.
  /// [operation] is a short description of transaction type, like "pageload".
  /// [id] is a transaction id, it is calculated automatically.
  /// [description] is a longer description of the transaction.
  ///   Human-readable identifier, like "GET /category/1/product?id=2"
  @pragma('vm:invisible')
  static R transaction<R>(
    // Short description of transaction type, like "pageload"
    String operation,
    // The body of the transaction
    R Function() body, {
    // Transaction id, if not specified, it is calculated automatically.
    TransactionId? id,
    // Description is a longer description of the transaction
    String? description,
  }) =>
      $transaction<R>(operation, body, id: id, description: description);

  /// Emit a log event.
  ///
  /// [event] is the log message or error that can be converted to a string
  /// [time] (optional) is the timestamp
  /// [level] (optional) is the severity level (a value between 0 and 2000)
  /// [name] (optional) is the name of the source of the log message
  /// [stackTrace] (optional) a stack trace associated with this log event
  /// [tags] (optional) a map of tags to add to the log event
  /// [breadcrumbs] (optional) a list of breadcrumbs to add to the log event
  /// [transactionId] (optional) the transaction id
  ///
  /// Levels:
  /// |      |          |                           |
  /// |------|----------|---------------------------|
  /// | 300  |  FINEST  |  very detailed messages   |
  /// | 400  |  FINER   |  fairly detailed tracing  |
  /// | 500  |  FINE    |  tracing information      |
  /// | 700  |  CONFIG  |  configuration messages   |
  /// | 800  |  INFO    |  informational messages   |
  /// | 900  |  WARNING |  warning messages         |
  /// | 1000 |  SEVERE  |  serious failures         |
  /// | 1200 |  SHOUT   |  extra loudness           |
  ///
  /// See also:
  /// + [l](https://pub.dev/packages/l)
  /// + [logging](https://pub.dev/packages/logging)
  @pragma('vm:invisible')
  static void log(
    Object event, {
    DateTime? time,
    String? name,
    int level = 0,
    StackTrace? stackTrace,
    Map<String, String>? tags,
    List<Object>? breadcrumbs,
    TransactionId? transactionId,
  }) =>
      $log(
        event,
        time: time,
        name: name,
        level: level,
        stackTrace: stackTrace,
        tags: tags,
        breadcrumbs: breadcrumbs,
        transactionId: transactionId,
      );
}
