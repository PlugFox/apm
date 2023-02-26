import 'dart:io';

import 'package:apm/apm.dart';

void main() {
  Monitoring.setup(project: 'example');
  Monitoring.capture(() => Monitoring.transaction('main', () async {
        print('Begin');
        for (var i = 0; i < 100; i++) {
          Monitoring.log('Counter: $i');
          await Future<void>.delayed(const Duration(milliseconds: 250));
        }
        print('End');
        await Future<void>.delayed(const Duration(seconds: 2));
      })).whenComplete(() => exit(0));
}
