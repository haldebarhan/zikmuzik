import 'package:flutter/material.dart';
import 'package:zikmuzik/services/preferences_service.dart';
import 'package:zikmuzik/widgets/home_page.dart';
import 'package:zikmuzik/widgets/onboarding_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PreferencesService.instance.init();
  bool? isOnboardingDone = await PreferencesService.instance.getBool(
    "onboarding_done",
  );
  runApp(MyApp(isOnboardingDone: isOnboardingDone ?? false));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isOnboardingDone});

  final bool isOnboardingDone;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: isOnboardingDone ? const HomePage() : const OnboardingPage(),
    );
  }
}
