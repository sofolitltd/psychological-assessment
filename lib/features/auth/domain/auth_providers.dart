import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/auth_service.dart';

final authServiceProvider = Provider<AuthService>((_) => AuthService());

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).authStateChanges,
);

final currentUserProvider = Provider<User?>(
  (ref) {
    final authState = ref.watch(authStateProvider);
    return authState.value;
  },
);

class UserStats {
  final int usageCount;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  const UserStats({
    this.usageCount = 0,
    this.createdAt,
    this.lastLogin,
  });
}

final userStatsProvider = FutureProvider<UserStats?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();
  if (!doc.exists) return UserStats();
  final data = doc.data()!;
  return UserStats(
    usageCount: data['usageCount'] as int? ?? 0,
    createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
  );
});
