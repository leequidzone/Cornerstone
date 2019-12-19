import 'package:flutter/services.dart';

enum Collection { profiles, users, events, locations}

enum AuthError {
  ERROR_EMAIL_ALREADY_IN_USE,
  ERROR_INVALID_EMAIL,
  ERROR_WRONG_PASSWORD,
  ERROR_USER_NOT_FOUND,
  ERROR_USER_DISABLED,
  ERROR_TOO_MANY_REQUESTS,
  ERROR_OPERATION_NOT_ALLOWED,
}

String authErrorTo(AuthError e) => e.toString().replaceAll("AuthError.", "");

bool isEqual(String s, AuthError e) => s == authErrorTo(e);

AuthError valueOf(PlatformException auth) {
  if (isEqual(auth.code, AuthError.ERROR_INVALID_EMAIL)) {
    return AuthError.ERROR_INVALID_EMAIL;
  }
  if (isEqual(auth.code, AuthError.ERROR_WRONG_PASSWORD)) {
    return AuthError.ERROR_WRONG_PASSWORD;
  }
  if (isEqual(auth.code, AuthError.ERROR_USER_DISABLED)) {
    return AuthError.ERROR_USER_DISABLED;
  }
  if (isEqual(auth.code, AuthError.ERROR_TOO_MANY_REQUESTS)) {
    return AuthError.ERROR_TOO_MANY_REQUESTS;
  }
  if (isEqual(auth.code, AuthError.ERROR_OPERATION_NOT_ALLOWED)) {
    return AuthError.ERROR_OPERATION_NOT_ALLOWED;
  }
  return null;
}