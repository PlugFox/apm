//import 'dart:isolate';
//import 'dart:ui' as ui;

import 'package:meta/meta.dart';

import 'variables.dart';

/// Setup the application performance monitoring library.
@internal
@pragma('vm:invisible')
void $setup({required String project, required String uri}) {
  /* const name = 'apm';
  final sendPort = ui.IsolateNameServer.lookupPortByName(name);
  if (sendPort != null) sendPort.send(-1);
  final rcvPort = ReceivePort();
  ui.IsolateNameServer.registerPortWithName(...); */
  $project = project;
  $uri = Uri.tryParse(uri);
}
