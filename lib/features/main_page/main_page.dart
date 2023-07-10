import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/mainPage';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () => {Navigator.pushNamed(context, '/mapPage')},
                child: const Text('Карта'))
          ],
        ),
      ),
    );
  }
}
