import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/auth_providers.dart';
import '../../auth/presentation/dialogs/login_dialog.dart';

void Function() requireAuth(BuildContext context, WidgetRef ref, VoidCallback onAuthenticated) {
  return () {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      onAuthenticated();
    } else {
      showLoginDialog(context, ref);
    }
  };
}
