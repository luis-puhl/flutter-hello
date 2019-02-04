import 'dart:developer';
import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';


const bool _hasTimeline =
    const bool.fromEnvironment("dart.developer.timeline", defaultValue: false);

dynamic timeIt(Function function, [String name = 'TimeIt']) {
  /// Returns the current value from the trace clock.
  /// external int _getTraceClock();
  int start = Timeline.now;
  Timeline.startSync(name);
  try {
    return function();
  } finally {
    Timeline.finishSync();
    int endTrace = Timeline.now;
    start = start is int ? start : 0;
    endTrace = endTrace is int ? endTrace : 0;
    double timeMs = (endTrace - start) * 0.001;
    String jankStatus = timeMs >= 16 ? (_hasTimeline ? ' JANK DETECTED!!!' : ' **') : '';
    print('[' + name + '] trace clock time ' + timeMs.round().toString() + 'ms' + jankStatus);
  }
}

Future<R> computeIt<Q, R>(ComputeCallback<Q, R> callback, Q message) async {
  throw 'Compute is broken, flutter and dart compain.';
  final ReceivePort resultPort = ReceivePort();
  final ReceivePort errorPort = ReceivePort();
  final Isolate isolate = await Isolate.spawn<Map>(
    _spawn,
    {'callback': callback, 'message': message, 'resultPort': resultPort},
    errorsAreFatal: true,
    onExit: resultPort.sendPort,
    onError: errorPort.sendPort,
  );
  final Completer<R> result = Completer<R>();
  errorPort.listen((dynamic errorData) {
    assert(errorData is List<dynamic>);
    assert(errorData.length == 2);
    final Exception exception = Exception(errorData[0]);
    final StackTrace stack = StackTrace.fromString(errorData[1]);
    if (result.isCompleted) {
      Zone.current.handleUncaughtError(exception, stack);
    } else {
      result.completeError(exception, stack);
    }
  });
  resultPort.listen((dynamic resultData) {
    assert(resultData == null || resultData is R);
    if (!result.isCompleted)
      result.complete(resultData);
  });
  await result.future;
  resultPort.close();
  errorPort.close();
  isolate.kill();
  return result.future;
}

void _spawn<Q, R>(Map map) {
  R result;
  result = map['callback']( map['message']);
  map['resultPort'].send(result);
}