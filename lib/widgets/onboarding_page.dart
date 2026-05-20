import 'package:flutter/material.dart';
import 'package:zikmuzik/models/onboard_item.dart';
import 'package:zikmuzik/services/preferences_service.dart';
import 'package:zikmuzik/widgets/home_page.dart';
import 'package:zikmuzik/widgets/onboard_item_widget.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<OnboardItem> _pages = [
    const OnboardItem(
      title: 'Faites vibrer votre réseau',
      description:
          'Rencontrez des profils musicaux de tous horizons, du amateur passionné au professionnel aguerri.',
      lottieUrl: 'assets/lottie/music-group.json',
    ),
    const OnboardItem(
      title: 'Des besoins ? Publiez',
      description:
          'Recherchez un guitariste pour un groupe, un DJ pour un événement ou un ingé son en quelques secondes.',
      lottieUrl: 'assets/lottie/activity.json',
    ),
    const OnboardItem(
      title: 'Des studios sur mesure',
      description:
          'Trouvez et louez des salles de répétition équipées ou des salles de concert prêtes à vous accueillir.',
      lottieUrl: 'assets/lottie/artman.json',
    ),
    const OnboardItem(
      title: 'Prêt à monter sur scène ?',
      description:
          'Créez votre profil en un instant et commencez à partager votre passion.',
      lottieUrl: 'assets/lottie/singer.json',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(microseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      await PreferencesService.instance.setOnboardingScreen(
        'onboarding_done',
        true,
      );
      if (mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (int value) => setState(() {
                  _currentPage = value;
                }),
                itemBuilder: (context, index) =>
                    OnboardItemWidget(item: _pages[index]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  height: 10,
                  width: _currentPage == index ? 18 : 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _next,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  textStyle: const TextStyle(fontWeight: .bold, fontSize: 16),
                ),
                child: Text(
                  _currentPage == _pages.length - 1 ? 'Commencer' : 'Suivant',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
