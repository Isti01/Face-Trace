import 'package:face_app/bloc/firebase/firestore_queries.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

RegExp emailRegex = RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
),
    passwordRegex = RegExp(
  r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$",
);

bool isEmpty(String text) => text == null || text.trim().isEmpty;

Future<bool> logInWithGoogle() async {
  try {
    final signIn = GoogleSignIn(scopes: ['email']);

    await signIn.signOut();
    final googleUser = await signIn.signIn();
    final userAuthentication = await googleUser.authentication;

    final authCredential = GoogleAuthProvider.getCredential(
      idToken: userAuthentication.idToken,
      accessToken: userAuthentication.accessToken,
    );

    final authResult = await auth.signInWithCredential(authCredential);

    final user = authResult.user;

    return user != null;
  } catch (e, s) {
    print([e, s]);
  }
  return false;
}

Future<bool> register(
  BuildContext context,
  String email,
  String pass,
  Function(String error) onRegisterFailed,
) async {
  try {
    final authResult = await auth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );

    final user = authResult.user;
    final successful = user != null;

    if (!successful) errorCodeToCallback(context, '', onRegisterFailed);

    return successful;
  } on PlatformException catch (e, s) {
    print([e, s]);

    errorCodeToCallback(context, e.code, onRegisterFailed);
  } catch (e, s) {
    print([e, s]);
    errorCodeToCallback(context, '', onRegisterFailed);
  }

  return false;
}

Future<bool> logIn(
  BuildContext context,
  String email,
  String pass,
  Function(String error) onLoginFailed,
) async {
  try {
    final result = await auth.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );

    bool successful = result != null;

    if (!successful) errorCodeToCallback(context, '', onLoginFailed);

    return successful;
  } on PlatformException catch (e, s) {
    print([e, s]);

    errorCodeToCallback(context, e.code, onLoginFailed);
  } catch (e, s) {
    print([e, s]);

    errorCodeToCallback(context, '', onLoginFailed);
  }
  return false;
}

bool forgotPassword(
    BuildContext context, String email, onResetFailed(String error)) {
  try {
    auth.sendPasswordResetEmail(email: email);
    return true;
  } on PlatformException catch (e, s) {
    print([e, s]);
    errorCodeToCallback(context, e.code, onResetFailed);
  } catch (e) {
    errorCodeToCallback(context, '', onResetFailed);
  }
  return false;
}

String validateEmail(BuildContext context, String email) {
  final AppLocalizations localizations = AppLocalizations.of(context);
  if (isEmpty(email)) return localizations.noEmail;

  if (emailRegex.hasMatch(email)) return null;

  return localizations.wrongEmail;
}

String validatePasswords(BuildContext context, String pass1, String pass2) {
  final AppLocalizations localizations = AppLocalizations.of(context);

  if (isEmpty(pass2)) return localizations.noPassword;

  if (pass1 == pass2) return null;

  return localizations.notMatchingPasswords;
}

String validatePasswordStrength(
    BuildContext context, String password, bool onlyIsNotEmpty) {
  final AppLocalizations localizations = AppLocalizations.of(context);

  if (isEmpty(password)) return localizations.noPassword;

  if (onlyIsNotEmpty) return null;
  if (passwordRegex.hasMatch(password.trim())) return null;

  return localizations.wrongPassword;
}

errorCodeToCallback(BuildContext context, String errorCode,
        Function(String error) callback) =>
    callback(errorCodeToString(context, errorCode));

errorCodeToString(BuildContext context, String errorCode) {
  final AppLocalizations localizations = AppLocalizations.of(context);

  switch (errorCode) {
    case 'ERROR_WEAK_PASSWORD':
      return localizations.weakPassword;
    case 'ERROR_EMAIL_ALREADY_IN_USE':
      return localizations.emailAlreadyInUse;
    case 'ERROR_INVALID_EMAIL':
      return localizations.invalidEmail;
    case 'ERROR_WRONG_PASSWORD':
      return localizations.wrongPasswordError;
    case 'ERROR_USER_NOT_FOUND':
      return localizations.userNotFound;
    case 'ERROR_USER_DISABLED':
      return localizations.userDisabled;
    case 'ERROR_TOO_MANY_REQUESTS':
      return localizations.tooManyRequests;
  }
}
