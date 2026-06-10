import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'core/design_system/app_theme.dart';
import 'features/about/presentation/about_screen.dart';
import 'features/assessment/presentation/result_screen_loader.dart';
import 'features/assessment/presentation/runner_screen_loader.dart';
import 'features/assessment/presentation/test_detail_screen.dart';
import 'features/assessment/presentation/test_list_screen.dart';
import 'features/upcoming/presentation/upcoming_screen.dart';

const _titleColor = Color(0xFF1A73E8);void main() {
  // Enable path-based URL strategy for web (removes the # from URLs)
  usePathUrlStrategy();
  //  if (kIsWeb) {
  //   setUrlStrategy(PathUrlStrategy());
  // }
  GoRouter.optionURLReflectsImperativeAPIs = true;

  //
  runApp(const ProviderScope(child: PsychologicalAssessmentApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage(
        child: Title(title: 'Tests - Psychological Assessment', color: _titleColor, child: TestListScreen()),
      ),
    ),
    GoRoute(
      path: '/upcoming',
      pageBuilder: (context, state) => NoTransitionPage(
        child: Title(title: 'Upcoming - Psychological Assessment', color: _titleColor, child: UpcomingScreen()),
      ),
    ),
    GoRoute(
      path: '/about',
      pageBuilder: (context, state) => NoTransitionPage(
        child: Title(title: 'About - Psychological Assessment', color: _titleColor, child: AboutScreen()),
      ),
    ),

    GoRoute(
      path: '/test/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(child: TestDetailScreen(testId: id));
      },
      routes: [
        GoRoute(
          path: 'run',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(child: RunnerScreenLoader(testId: id));
          },
        ),
        GoRoute(
          path: 'result',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(child: ResultScreenLoader(testId: id));
          },
        ),
      ],
    ),
  ],
);

class PsychologicalAssessmentApp extends StatelessWidget {
  const PsychologicalAssessmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Psychological Assessment',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
