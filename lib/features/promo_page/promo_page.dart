import 'package:flutter/material.dart';

class PromoPage extends StatelessWidget {
  static const routeName = '/promoPage';

  const PromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Text('Promo'),
      ),
    );
  }
}
