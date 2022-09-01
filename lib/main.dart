import 'package:cis_state/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BreakingApp(
    appRouter: AppRouter(),
  ));
}

class BreakingApp extends StatelessWidget {
  const BreakingApp({Key? key, required this.appRouter}) : super(key: key);

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
