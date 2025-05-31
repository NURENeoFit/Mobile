import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/models/workout.dart';

import 'package:neofit_mobile/screens/login/login_screen.dart';
import 'package:neofit_mobile/screens/main/pages/profile/profile.dart';
import 'package:neofit_mobile/screens/main/pages/profile/details.dart';
import 'package:neofit_mobile/screens/main/pages/profile/favourites.dart';
import 'package:neofit_mobile/screens/main/pages/profile/settings.dart';
import 'package:neofit_mobile/screens/main/pages/profile/statistics.dart';
import 'package:neofit_mobile/screens/main/pages/profile/abonnement.dart';
import 'package:neofit_mobile/screens/main/pages/trainings/exercise.dart';
import 'package:neofit_mobile/screens/register/register_screen.dart';
import 'package:neofit_mobile/screens/main/root.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/training/:id',
      builder: (context, state) {
        final workout = state.extra as Workout;
        return TrainingDetailPage(workout: workout);
      },
    ),
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
);