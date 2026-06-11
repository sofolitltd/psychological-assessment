import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:psychological_assessment/app/not_found_screen.dart';
import 'package:psychological_assessment/features/about/presentation/screens/about_screen.dart';
import 'package:psychological_assessment/features/assessment/presentation/screens/result_screen_loader.dart';
import 'package:psychological_assessment/features/assessment/presentation/screens/runner_screen_loader.dart';
import 'package:psychological_assessment/features/assessment/presentation/screens/test_detail_screen.dart';
import 'package:psychological_assessment/features/assessment/presentation/screens/test_list_screen.dart';
import 'package:psychological_assessment/features/upcoming/presentation/screens/upcoming_screen.dart';

const _titleColor = Color(0xFF1A73E8);

final router = GoRouter(
  initialLocation: '/',
  errorPageBuilder: (context, state) => NoTransitionPage(
    child: NotFoundScreen(),
  ),
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
