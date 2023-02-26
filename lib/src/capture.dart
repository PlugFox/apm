import 'dart:async';

import 'package:meta/meta.dart';

import 'log.dart';

/// Capture [print]s from [body] and send them to [log] function.
@internal
@pragma('vm:invisible')
R $capture<R>(R Function() body) => runZoned<R>(
      body,
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          $log(line);
          // Replace [self] with [parent] zone
          //self.print(line);
          parent.print(zone, line);
        },
      ),
    );
