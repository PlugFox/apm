import 'package:apm/src/generated/apm.pb.dart' as generated;
import 'package:apm/src/message.dart';
import 'package:stack_trace/stack_trace.dart' as st;
import 'package:test/test.dart';

void main() => group('message', () {
      test('convert_log', () {
        final project = 'project';
        final event = 'hello-world';
        final time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final name = 'name';
        final level = 700;
        final stackTrace = StackTrace.current;
        final tags = <String, String>{'key': 'value'};
        final breadcrumbs = <String>['1', '2', '3'];
        final transactionId = 'transactionId';
        final log = generated.Log(
          project: project,
          event: event,
          time: time,
          name: name,
          level: level,
          stack: st.Trace.format(stackTrace),
          tags: tags,
          breadcrumbs: breadcrumbs,
          span: transactionId,
        );
        final bytes = $messagesCodec.encode(log);
        expect(
            $messagesCodec.decode(bytes),
            isA<generated.Log>().having(
              (l) => l.level,
              'log.level',
              equals(level),
            ));
      });

      test('convert_transaction', () {
        final project = 'project';
        final operation = 'operation';
        final id = 'id';
        final description = 'description';
        final transaction = generated.Transaction(
          project: project,
          operation: operation,
          id: id,
          description: description,
        );
        final bytes = $messagesCodec.encode(transaction);
        final result = $messagesCodec.decode(bytes);
        expect(
            result,
            isA<generated.Transaction>().having(
              (t) => t.id,
              'transaction.id',
              equals(id),
            ));
      });
    });
