import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:newproject/hash_extension.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _verifyUser(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _verifyUser(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;

  final username = body['username'] as String?;
  final password = body['password'] as String?;

  try {
    final hashQuery =
        // ignore: lines_longer_than_80_chars
        await context.read<Connection>().execute(
              "SELECT password_hash FROM users WHERE username = '$username'",
            );

    // needs error handling if username does not exist
    // (sends correct error request)
    // if username does not exist, causes error in backend

    final dbHash = hashQuery[0][0].toString();
    final isVerified = BCrypt.checkpw(password!, dbHash);
    print(isVerified);

    if (!isVerified) {
      return Response(statusCode: HttpStatus.unauthorized);
    }

    return Response.json(
      body: {'isVerified': isVerified, 'user-id': username!.shaHash},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.unauthorized);
  }
}
