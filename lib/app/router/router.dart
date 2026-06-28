import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/not_found_screen.dart';
import '/core/widgets/pdf_viewer_screen.dart';
import '/features/about/presentation/screens/about_screen.dart';
import '/features/about/presentation/screens/acknowledgements_screen.dart';
import '/features/assessment/presentation/screens/result_screen_loader.dart';
import '/features/assessment/presentation/screens/runner_screen_loader.dart';
import '/features/assessment/presentation/screens/test_detail_screen.dart';
import '/features/assessment/presentation/screens/test_list_screen.dart';
import '/features/upcoming/presentation/screens/upcoming_detail_screen.dart';
import '/features/upcoming/presentation/screens/upcoming_screen.dart';

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
      path: '/upcoming/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(child: UpcomingDetailScreen(testId: id));
      },
      routes: [
        GoRoute(
          path: 'pdf-viewer',
          pageBuilder: (context, state) {
            final url = state.uri.queryParameters['url'] ?? '';
            final title = state.uri.queryParameters['title'] ?? 'PDF';
            return NoTransitionPage(child: PdfViewerScreen(url: url, title: title));
          },
        ),
      ],
    ),
    GoRoute(
      path: '/about',
      pageBuilder: (context, state) => NoTransitionPage(
        child: Title(title: 'About - Psychological Assessment', color: _titleColor, child: AboutScreen()),
      ),
      routes: [
        GoRoute(
          path: 'acknowledgements',
          pageBuilder: (context, state) => NoTransitionPage(
            child: AcknowledgementsScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/pdf-viewer',
      pageBuilder: (context, state) {
        final url = state.uri.queryParameters['url'] ?? '';
        final title = state.uri.queryParameters['title'] ?? 'PDF';
        return NoTransitionPage(child: PdfViewerScreen(url: url, title: title));
      },
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
        GoRoute(
          path: 'pdf-viewer',
          pageBuilder: (context, state) {
            final url = state.uri.queryParameters['url'] ?? '';
            final title = state.uri.queryParameters['title'] ?? 'PDF';
            return NoTransitionPage(child: PdfViewerScreen(url: url, title: title));
          },
        ),
      ],
    ),
  ],
);

