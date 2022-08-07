// ignore_for_file: cascade_invocations

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// https://github.com/dart-lang/dart-docker/
///
///
///
void main(List<String> arguments) async {
  print('\nStarting...\n\n');
  InternetAddress host =
      InternetAddress('/var/run/docker.sock', type: InternetAddressType.unix);

  Socket socket = await Socket.connect(host, 0);

  ProcessSignal.sigint.watch().listen((dynamic event) => socket.close());
  bool first = true;
  socket.listen(
    (Uint8List event) {
      if (first) {
        first = false;
        // TODO: Check if connection is successful.
        print('First response:');
        print(String.fromCharCodes(event).trim());
        print('');
        return;
      }

      print('------');
      if (event.length > 5) {
        print(event.sublist(0, 5));
        String body = String.fromCharCodes(event.sublist(5)).trim();
        print(body);
        print('Length: ${body.length}');

        Map<String, dynamic> map = json.decode(body);
        print(map);
      } else {
        print(event);
      }
      print('||||||');
    },
    onError: (dynamic e, StackTrace s) {
      print('onError: $e');
      print(s);
    },
    onDone: () async {
      print('onDone');
      socket.destroy();
      // await socket.done;
      exit(0);
    },
  );

  socket.writeln('GET /v1.41/events HTTP/1.1');
  socket.writeln('Host: localhost');
  socket.writeln('User-Agent: curl/7.81.0');
  socket.writeln('Accept: */*');
  socket.writeln();

  // dynamic d = await socket.close();

  // print(d);

  // await socket.done;

  // exit(0);
}
