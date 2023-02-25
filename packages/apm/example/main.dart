import 'dart:io';

import 'package:apm/apm.dart';

void main() => APM
    .capture(() => APM.transaction('main', () async {
          print('Begin');
          for (var i = 0; i < 100; i++) {
            APM.log('Counter: $i');
            await Future<void>.delayed(const Duration(milliseconds: 50));
          }
          print('End');
        }))
    .whenComplete(() => exit(0));
