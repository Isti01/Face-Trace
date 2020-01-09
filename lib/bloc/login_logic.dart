import 'package:face_app/bloc/firebase/firestore_queries.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    print(user.toString());

    final successful = user != null;

    if (!successful) errorCodeToCallback('', onRegisterFailed);

    return successful;
  } on PlatformException catch (e, s) {
    print([e, s]);

    errorCodeToCallback(e.code, onRegisterFailed);
  } catch (e, s) {
    print([e, s]);
    errorCodeToCallback('', onRegisterFailed);
  }

  return false;
}

Future<bool> logIn(
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

    if (!successful) errorCodeToCallback('', onLoginFailed);

    return successful;
  } on PlatformException catch (e, s) {
    print([e, s]);

    errorCodeToCallback(e.code, onLoginFailed);
  } catch (e, s) {
    print([e, s]);

    errorCodeToCallback('', onLoginFailed);
  }
  return false;
}

bool forgotPassword(String email, onResetFailed(String error)) {
  try {
    auth.sendPasswordResetEmail(email: email);
    return true;
  } on PlatformException catch (e, s) {
    print([e, s]);
    errorCodeToCallback(e.code, onResetFailed);
  } catch (e) {
    errorCodeToCallback('', onResetFailed);
  }
  return false;
}

String validateEmail(String email) {
  if (isEmpty(email)) return "Nincs email megadva";

  if (emailRegex.hasMatch(email)) return null;

  return "A megadott email cím hibás.";
}

String validatePasswords(String pass1, String pass2) {
  if (isEmpty(pass2)) return "Nincs jelszó megadva";

  if (pass1 == pass2) return null;

  return 'A két jelszó nem egyezik.';
}

String validatePasswordStrength(String password, bool onlyIsNotEmpty) {
  if (isEmpty(password)) return "Nincs jelszó megadva";

  if (onlyIsNotEmpty) return null;
  if (passwordRegex.hasMatch(password.trim())) return null;

  return "A Jelszónak minimum 8 karakter hosszúnak kell lennie és tartalmaznia kell számokat és betűket";
}

errorCodeToCallback(String errorCode, Function(String error) callback) =>
    callback(errorCodeToString(errorCode));

errorCodeToString(String errorCode) {
  switch (errorCode) {
    case 'ERROR_WEAK_PASSWORD':
      return 'A megadott jelszó gyenge';
    case 'ERROR_EMAIL_ALREADY_IN_USE':
      return 'Az email már használatban van';
    case 'ERROR_INVALID_EMAIL':
      return 'Az email helytelen';
    case 'ERROR_WRONG_PASSWORD':
      return 'A jelszó helytelen';
    case 'ERROR_USER_NOT_FOUND':
      return 'A felhsználó nem létezik';
    case 'ERROR_USER_DISABLED':
      return 'A felhasználó le van tiltva';
    case 'ERROR_TOO_MANY_REQUESTS':
      return 'Túl sokszor próbált belépni ezzel a felhasználóval.';
  }
}
