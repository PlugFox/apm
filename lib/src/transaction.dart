import 'dart:async';

import 'package:meta/meta.dart';

import 'generated/apm.pb.dart' as generated;
import 'message.dart';
import 'transport.dart';
import 'variables.dart';

/// Transaction id
typedef TransactionId = String;

/// Runs [body] in a transaction.
@internal
@pragma('vm:invisible')
R $transaction<R>(
  String operation,
  R Function() body, {
  TransactionId? id,
  String? description,
}) {
  final transaction = Transaction(id, operation, description);
  if ($project == null || $uri == null) return body();
  final message = generated.Transaction(
    project: $project,
    id: transaction.id,
    operation: transaction.operation,
    description: transaction.description,
  );
  Transport().send($messagesCodec.encode(message));
  return runZoned<R>(
    body,
    zoneValues: <Type, Transaction>{
      Transaction: transaction,
    },
  );
}

/// The current transaction id
TransactionId? $transactionId() {
  final transaction = Zone.current[Transaction];
  if (transaction is! Transaction) return null;
  return transaction.id;
}

/// A transaction is a logical unit of work performed by a user
@immutable
class Transaction {
  const Transaction._(this.id, this.operation, this.description);
  static int _$txnCounter = 0;

  /// A transaction is a logical unit of work performed by a user
  factory Transaction(
    TransactionId? id,
    String? operation,
    String? description,
  ) =>
      Transaction._(
        id ??
            '${operation?.split(' ').join('_') ?? 'txn'}'
                '-'
                '${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}'
                '-'
                '${(_$txnCounter++).toRadixString(36)}',
        operation,
        description,
      );

  /// The unique identifier of the transaction
  final TransactionId id;

  /// Short description of transaction type, like "pageload"
  final String? operation;

  /// Description is a longer description of the transaction
  /// Human-readable identifier, like "GET /category/1/product?id=2"
  final String? description;
}
