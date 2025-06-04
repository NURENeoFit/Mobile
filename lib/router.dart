import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/models/trainings/trainer.dart';
import 'package:neofit_mobile/models/trainings/workout_program.dart';

import 'package:neofit_mobile/screens/login/login_screen.dart';
import 'package:neofit_mobile/screens/main/pages/profile/profile.dart';
import 'package:neofit_mobile/screens/main/pages/profile/details.dart';
import 'package:neofit_mobile/screens/main/pages/profile/favourites.dart';
import 'package:neofit_mobile/screens/main/pages/profile/settings.dart';
import 'package:neofit_mobile/screens/main/pages/profile/statistics.dart';
import 'package:neofit_mobile/screens/main/pages/profile/abonnement.dart';
import 'package:neofit_mobile/screens/main/pages/trainings/exercises.dart';
import 'package:neofit_mobile/screens/register/complete_profile.dart';
import 'package:neofit_mobile/screens/register/register_screen.dart';
import 'package:neofit_mobile/screens/main/root.dart';
import 'package:neofit_mobile/utils/auth_storage.dart';

// Main app router configuration with route protection based on the token
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Login screen route
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // Registration screen route
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/complete_profile',
      builder: (context, state) => const CompleteProfilePage(),
    ),
    // Main screen (home) route
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    // Workout program detail page with required extra data
    GoRoute(
      path: '/program_detail',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final WorkoutProgram program = data['workoutProgram'] as WorkoutProgram;
        final Trainer trainer = data['trainer'] as Trainer;
        return TrainingDetailPage(workoutProgram: program, trainer: trainer);
      },
    ),
    // Profile routes (with nested subpages)
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) => const DetailsPage(),
        ),
        GoRoute(
          path: 'abonnement',
          builder: (context, state) => const AbonnementPage(),
        ),
        GoRoute(
          path: 'favourites',
          builder: (context, state) => const FavouritesPage(),
        ),
        GoRoute(
          path: 'statistics',
          builder: (context, state) => const StatisticsPage(),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],

  // Route protection: Redirect based on token existence
  redirect: (context, state) {
    final hasToken = AuthStorage.token != null && AuthStorage.token!.isNotEmpty;
    final isLogin = state.fullPath == '/login';
    final isRegister = state.fullPath == '/register';

    if (!hasToken && !isLogin && !isRegister) {
      return '/login';
    }

    return null;
  },
);
