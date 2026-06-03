import 'package:flutter/material.dart';
import 'package:zikmuzik/widgets/announcements_screen.dart';
import 'package:zikmuzik/widgets/categories_screen.dart';
import 'package:zikmuzik/widgets/shop_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1;

  final List<Widget> _pages = [
    CategoriesScreen(),
    AnnouncementsScreen(),
    ShopScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _pages[currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          indicatorColor: Colors.blue,
          backgroundColor: Colors.deepOrangeAccent,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(color: Colors.white),
          ),
          iconTheme: WidgetStatePropertyAll(IconThemeData(color: Colors.white)),
        ),
        child: NavigationBar(
          onDestinationSelected: (value) =>
              setState(() => currentIndex = value),
          selectedIndex: currentIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.search),
              label: "Catégories",
            ),
            NavigationDestination(
              icon: Icon(Icons.accessibility_new_sharp),
              label: "Annonces",
            ),
            NavigationDestination(
              icon: Icon(Icons.shop_two_sharp),
              label: "Boutique",
            ),
          ],
        ),
      ),
    );
  }
}
