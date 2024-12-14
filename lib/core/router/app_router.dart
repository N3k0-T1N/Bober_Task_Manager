import 'package:bober_task_manager/feature/task/page/task_page.dart';
import 'package:bober_task_manager/feature/settings/settings.dart';
import 'package:bober_task_manager/feature/auth/page/login.dart';
import 'package:bober_task_manager/feature/auth/page/register.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: LoginPage.route,
    routes: [
      GoRoute(
        path: LoginPage.route,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RegisterPage.route,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: TasksPage.route,
        builder: (context, state) => const TasksPage(),
      ),
      GoRoute(
        path: SettingsPage.route,
        builder: (context, state) => SettingsPage(),
      )
    ],
  );
}