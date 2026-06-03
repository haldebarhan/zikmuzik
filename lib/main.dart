import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zikmuzik/core/services/preferences_service.dart';
import 'package:zikmuzik/widgets/biometric_setup_screen.dart';
import 'package:zikmuzik/widgets/home_page.dart';
import 'package:zikmuzik/widgets/login_page.dart';
import 'package:zikmuzik/widgets/onboarding_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

List<GetPage> pages = [
  GetPage(name: '/', page: () => HomePage()),
  GetPage(name: '/login', page: () => LoginPage()),
  GetPage(name: '/onboarding', page: () => OnboardingPage()),
  GetPage(name: '/biometric', page: () => BiometricSetupScreen()),
];
Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  PreferencesService.instance.init();
  bool? isOnboardingDone = await PreferencesService.instance.getBool(
    "onboarding_done",
  );
  initializeDateFormatting(
    'fr_FR',
    null,
  ).then((_) => runApp(MyApp(isOnboardingDone: isOnboardingDone ?? false)));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isOnboardingDone});

  final bool isOnboardingDone;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: pages,
      debugShowCheckedModeBanner: false,
      title: 'zikmuzik',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: isOnboardingDone ? const HomePage() : const OnboardingPage(),
      navigatorKey: Get.key,
    );
  }
}
