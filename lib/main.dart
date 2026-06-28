import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app/router/router.dart';
import 'core/design_system/app_theme.dart';
import 'core/design_system/theme_notifier.dart';
import 'core/utils/logger.dart';
import 'features/auth/data/auth_service.dart';
import 'features/auth/domain/auth_providers.dart';
import 'firebase_options.dart';

final _log = AppLogger('Main');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  final user = FirebaseAuth.instance.currentUser;
  _log.info('App start — currentUser: ${user?.email ?? 'null'}');

  runApp(const ProviderScope(child: PsychologicalAssessmentApp()));
}

class PsychologicalAssessmentApp extends ConsumerWidget {
  const PsychologicalAssessmentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<User?>(currentUserProvider, (previous, next) {
      if (next != null && previous == null) {
        _log.info('User signed in: ${next.email}');
        AuthService.saveUserToFirestore(next);
      } else if (next == null && previous != null) {
        _log.info('User signed out (was ${previous.email})');
      }
    });

    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
    title: 'Psychological Assessment',
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: themeMode,
    routerConfig: router,
    debugShowCheckedModeBanner: false,
        );
  }
}
