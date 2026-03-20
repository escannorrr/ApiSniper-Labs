import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';

// Screens - We'll create these next
import '../core/layouts/dashboard_layout.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/landing/presentation/pages/landing_page.dart';
import '../features/landing/presentation/pages/pricing_page.dart';
import '../features/landing/presentation/pages/docs_page.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/projects/presentation/screens/projects_screen.dart';
import '../features/projects/presentation/pages/project_details_page.dart';
import '../features/projects/presentation/pages/project_endpoints_page.dart';
import '../features/endpoints/presentation/screens/endpoint_explorer_screen.dart';
import '../features/security_analysis/presentation/screens/security_analysis_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/settings/presentation/pages/profile_page.dart';
import '../features/settings/presentation/pages/account_page.dart';
import '../features/settings/presentation/pages/ai_settings_page.dart';
import '../features/billing/presentation/screens/pricing_screen.dart';
import '../features/billing/presentation/screens/checkout_screen.dart';
import '../features/billing/presentation/screens/payment_success_screen.dart';
import '../features/billing/presentation/screens/billing_management_screen.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          final redirect = state.extra as String?;
          return LoginScreen(redirectPath: redirect);
        },
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/pricing',
        name: 'public_pricing',
        builder: (context, state) => const PricingPage(),
      ),
      GoRoute(
        path: '/docs',
        name: 'docs',
        builder: (context, state) => const DocsPage(),
      ),
      // Standalone full-screen pages
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return DashboardLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: '/projects',
            name: 'projects',
            pageBuilder: (context, state) => const NoTransitionPage(child: ProjectsScreen()),
          ),
          GoRoute(
            path: '/project/:id',
            name: 'project_details',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return NoTransitionPage(child: ProjectDetailsPage(projectId: id));
            },
            routes: [
              GoRoute(
                path: 'endpoints',
                name: 'project_endpoints',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return NoTransitionPage(child: ProjectEndpointsPage(projectId: id));
                },
              ),
              GoRoute(
                path: 'security',
                name: 'security',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return NoTransitionPage(child: SecurityAnalysisScreen(projectId: id));
                },
              ),
            ],
          ),
          GoRoute(
            path: '/endpoints',
            name: 'endpoints',
            pageBuilder: (context, state) {
              final projectId = state.uri.queryParameters['projectId'];
              return NoTransitionPage(child: EndpointExplorerScreen(projectId: projectId));
            },
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => const NoTransitionPage(child: SettingsScreen()),
            routes: [
              GoRoute(
                path: 'profile',
                name: 'profile',
                pageBuilder: (context, state) => const NoTransitionPage(child: ProfilePage()),
              ),
              GoRoute(
                path: 'account',
                name: 'account',
                pageBuilder: (context, state) => const NoTransitionPage(child: AccountPage()),
              ),
              GoRoute(
                path: 'ai-config',
                name: 'ai_config',
                pageBuilder: (context, state) => const NoTransitionPage(child: AiSettingsPage()),
              ),
            ],
          ),

          GoRoute(
            path: '/checkout',
            name: 'checkout',
            pageBuilder: (context, state) => const NoTransitionPage(child: CheckoutScreen()),
          ),
          GoRoute(
            path: '/billing',
            name: 'billing',
            pageBuilder: (context, state) => const NoTransitionPage(child: BillingManagementScreen()),
          ),
        ],
      ),
    ],
    // Global redirection logic based on auth state
    refreshListenable: GoRouterRefreshStream(
      navigatorKey.currentContext?.read<AuthBloc>().stream ?? const Stream.empty(),
    ),
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final bool loggedIn = authState is AuthAuthenticated;
      final bool isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
      final bool isLandingRoute = state.matchedLocation == '/';
      final bool isPublicRoute = isAuthRoute || isLandingRoute || state.matchedLocation == '/pricing' || state.matchedLocation == '/docs';
      
      if (!loggedIn && !isPublicRoute) return '/login';
      if (loggedIn && (isAuthRoute || isLandingRoute)) return '/dashboard';
      return null;
    },
  );
}

// Helper class to convert Bloc stream to Listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
