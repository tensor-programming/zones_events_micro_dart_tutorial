import 'dart:async';

main() {
  runZoned(() async {
    example();
  }, onError: (e, stacktrace) {
    print('caught: $e');
  }, zoneSpecification: ZoneSpecification(print: (
    Zone self,
    ZoneDelegate parent,
    Zone zone,
    String message,
  ) {
    parent.print(zone, '${DateTime.now()}: $message');
  }));
}

Future example() async {
  await for (var x in streamer()) {
    print('Got $x');
    if (x == 9) throw ('error: $x');
  }
}

Future exampleOutOfZone() async {
  await for (var x in streamer()) {
    print('Got $x');
    if (x == 9) throw ('error: $x');
  }
}

Stream<int> streamer() async* {
  var duration = Duration(milliseconds: 100);
  for (var x = 0; x < 100; x++) {
    await Future.delayed(duration);
    yield x;
  }
}

// import 'dart:async';

// main(List<String> args) async {
//   EventLoop.callFunc(_fakeMain, []);
// }

// void _fakeMain(List<String> args) {
//   int x = 10;

//   _func() {
//     print(x);
//     x--;
//     if (x != 0) {
//       scheduleMicrotask(_func());
//     }
//   }

//   _func();
// }

// class EventLoop {
//   static final List<Function> queue = [];
//   static final List<Function> microtask = [];

//   static void run(Function function) {
//     print("queuing function");
//     queue.add(function);
//   }

//   static void runMicrotask(Function function) {
//     print("add microtask");
//     microtask.add(function);
//   }

//   static void eventLoop() {
//     while (microtask.isNotEmpty) {
//       microtask.removeAt(0)();
//     }
//     while (queue.isNotEmpty) {
//       while (microtask.isNotEmpty) {
//         microtask.removeAt(0)();
//       }
//       queue.removeAt(0)();
//     }

//     if (microtask.isNotEmpty || queue.isNotEmpty) {
//       eventLoop();
//     }
//   }

//   static void callFunc(Function func, List<String> args) {
//     var zone = Zone.current.fork(
//       specification: ZoneSpecification(scheduleMicrotask: (
//         zoneOne,
//         delegate,
//         zoneTwo,
//         func,
//       ) {
//         EventLoop.runMicrotask(func);
//       }, createTimer: (
//         zoneOne,
//         delegate,
//         zoneTwo,
//         duration,
//         func,
//       ) {
//         if (duration == Duration.zero) {
//           EventLoop.run(func);
//           return null;
//         } else {
//           return Timer(duration, func);
//         }
//       }),
//     );

//     zone.runUnary(func, args);
//     eventLoop();
//   }
// }
