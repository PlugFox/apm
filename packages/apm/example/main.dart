import 'dart:io';

import 'package:apm/apm.dart';

void main() {
  Monitoring.setup(project: 'example');
  Monitoring.capture(() => Monitoring.transaction('main', () async {
        print('Begin');
        for (var i = 0; i < 100; i++) {
          Monitoring.log('Counter: $i');
          await Future<void>.delayed(const Duration(milliseconds: 50));
        }
        print('End');
      })).whenComplete(() => exit(0));
}
