import 'dart:io';
import 'dart:math' as math;

import 'package:apm/apm.dart';

void main() {
  final rnd = math.Random();
  Monitoring.setup(project: 'example');
  final prefix = 'New';
  Monitoring.capture(() => Monitoring.transaction('main', () async {
        print('$prefix Begin');
        for (var i = 0; i < 15; i++) {
          Monitoring.log('$prefix Something: $i', level: rnd.nextInt(1001));
          await Future<void>.delayed(const Duration(milliseconds: 150));
        }
        print('$prefix End');
        await Future<void>.delayed(const Duration(seconds: 2));
      })).whenComplete(() => exit(0));
}
