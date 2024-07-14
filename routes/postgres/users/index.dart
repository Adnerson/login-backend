import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:newproject/hash_extension.dart';
import 'package:postgres/postgres.dart';

// _getUsers() is a debug function to test if the backend-db connection works

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    // HttpMethod.get => _getUsers(context),
    HttpMethod.post => _createUser(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

// 
// Future<Response> _getUsers(RequestContext context) async {
//   final users = <Map<String, dynamic>>[];
//   final results =
//       await context.read<Connection>().execute('SELECT * FROM users');

//   for (final row in results) {
//     users.add({
//       'id': row[0],
//       'username': row[1],
//       'email': row[2],
//       'hashed_password': row[3],
//     });
//   }
//   return Response.json(body: users);
// }

Future<Response> _createUser(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username'] as String?;
  final email = body['email'] as String?;
  final password = body['password'] as String?;
  
  final passwordHash = password!.passwordHash;

  try {
    final result = await context.read<Connection>().execute(
          // ignore: lines_longer_than_80_chars
          "INSERT INTO users (username, email, password_hash) VALUES ('$username', '$email', '$passwordHash')",
        );

    if (result.affectedRows == 1) {
      return Response.json(body: {'success': true});
    } else {
      return Response.json(body: {'success': false});
    }
  } catch (e) {
    return Response(statusCode: HttpStatus.connectionClosedWithoutResponse);
  }
}
