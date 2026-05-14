import 'package:flutter/material.dart';
import 'package:global_explorer/shared/routers/app_router.dart';
import 'package:go_router/go_router.dart';
import 'core/di/injection.dart';
import 'shared/theme/app_theme.dart';

Future<void> main() async {
  await initializeApp();
  runApp(
    buildProviderTree(
      child: GlobalExplorerApp(router: createAppRouter()),
    ),
  );
}

class GlobalExplorerApp extends StatelessWidget {
  const GlobalExplorerApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Global Explorer',
      theme: buildAppTheme(),
      routerConfig: router,
    );
  }
}
