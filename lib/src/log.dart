import 'package:meta/meta.dart';
import 'package:stack_trace/stack_trace.dart' as st;

import 'generated/apm.pb.dart' as generated;
import 'message.dart';
import 'transaction.dart';
import 'transport.dart';
import 'variables.dart';

/// Emit a log event.
@internal
@pragma('vm:invisible')
void $log(
  Object event, {
  DateTime? time,
  String? name,
  int level = 0,
  StackTrace? stackTrace,
  Map<String, String>? tags,
  List<Object>? breadcrumbs,
  String? transactionId,
}) {
  if ($project == null || $uri == null) return;
  final message = generated.Log(
    project: $project,
    event: event.toString(),
    time: (time ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000,
    name: name ?? '',
    level: level,
    stack: st.Trace.format(stackTrace ?? StackTrace.current),
    tags: tags ?? const <String, String>{},
    breadcrumbs: <String>[...?breadcrumbs?.map<String>((e) => e.toString())],
    span: transactionId ?? $transactionId() ?? '',
  );
  Transport().send($messagesCodec.encode(message));
}
