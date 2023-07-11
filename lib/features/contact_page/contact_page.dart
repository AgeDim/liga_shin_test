import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  static const routeName = '/contactPage';
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Text('Contact'),
      ),
    );
  }
}
