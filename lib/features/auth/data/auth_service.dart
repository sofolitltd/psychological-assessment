import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/utils/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _initialized = false;
  static const _log = AppLogger('AuthService');

  Future<void> ensureInitialized() async {
    if (!_initialized) {
      if (!kIsWeb) {
        _log.info('Initializing GoogleSignIn for mobile');
        await GoogleSignIn.instance.initialize();
      }
      _initialized = true;
    }
  }

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    await ensureInitialized();

    if (kIsWeb) {
      _log.info('Signing in with popup (web)');
      final result = await _auth.signInWithPopup(GoogleAuthProvider());
      _log.info('Sign-in successful: ${result.user?.email}');
      await saveUserToFirestore(result.user!);
      return result;
    }

    _log.info('Signing in with GoogleSignIn (mobile)');
    final googleAccount = await GoogleSignIn.instance.authenticate();
    final idToken = googleAccount.authentication.idToken;
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final userCredential = await _auth.signInWithCredential(credential);
    _log.info('Sign-in successful: ${userCredential.user?.email}');
    await saveUserToFirestore(userCredential.user!);
    return userCredential;
  }

  Future<void> signOut() async {
    _log.info('Signing out');
    if (!kIsWeb) {
      await GoogleSignIn.instance.signOut();
    }
    await _auth.signOut();
    _log.info('Signed out');
  }

  static Future<void> saveUserToFirestore(User user) async {
    _log.info('Saving user to Firestore: ${user.email}');
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('users').doc(user.uid);
    try {
      final doc = await userRef.get();
      if (!doc.exists) {
        await userRef.set({
          'name': user.displayName ?? '',
          'email': user.email,
          'photoUrl': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'usageCount': 0,
        });
        _log.info('New user created');
      } else {
        await userRef.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
        _log.info('User updated');
      }
    } catch (e, s) {
      _log.error('Failed to save user to Firestore', e, s);
    }
  }
}
