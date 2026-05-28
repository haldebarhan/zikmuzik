import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.search), label: "Catégories"),
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
    );
  }
}
