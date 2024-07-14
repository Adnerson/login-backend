import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:crypto/crypto.dart';

/// Add password hashing functionality to string
extension HashStringExtension on String {

  /// returns Bcrypt hash, including the salt within the hash.
  String get passwordHash {
    return BCrypt.hashpw(this, BCrypt.gensalt());
  }

  /// returns sh5256 hash
  String get shaHash {
    return sha256.convert(utf8.encode(this)).toString();
  }
}
