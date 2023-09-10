import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liga_shin_test/features/contact_page/contact_page.dart';
import 'package:liga_shin_test/features/main_page/main_page.dart';
import 'package:liga_shin_test/features/promo_page/promo_page.dart';
import 'package:provider/provider.dart';

import '../../model/data.dart';
import '../../model/data_provider.dart';
import '../../services/snack_bar.dart';
import '../service_card/service_card.dart';

class ServicesGrid extends StatefulWidget {
  const ServicesGrid({Key? key}) : super(key: key);

  @override
  State<ServicesGrid> createState() => _ServicesGridState();
}

class _ServicesGridState extends State<ServicesGrid> {
  @override
  Widget build(BuildContext context) {
    return (MediaQuery.of(context).orientation ==
        Orientation.portrait)
        ? Column(
      children: [
        Row(
          children: [
            Expanded(child: getCard(0)),
            const SizedBox(width: 10),
            Expanded(child: getCard(1)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: getCard(2)),
            const SizedBox(width: 10),
            Expanded(child: getCard(3)),
          ],
        )
      ],
    )
        : Column(
      children: [
        Row(
          children: [
            Expanded(child: getCard(0)),
            const SizedBox(width: 10),
            Expanded(child: getCard(1)),
            const SizedBox(width: 10),
            Expanded(child: getCard(2)),
            const SizedBox(width: 10),
            Expanded(child: getCard(3)),
          ],
        ),
      ],
    );
  }

  Widget getCard(index) {
    bool isShimontEmpty = Provider.of<DataProvider>(context)
        .getShimont.isEmpty;
    bool isCarWashingEmpty = Provider.of<DataProvider>(context)
        .getCarWashing.isEmpty;
    final cards = [
      ServiceCard(
        onTap: isShimontEmpty
            ? () {
          SnackBarService.showSnackBar(
              context,
              "Нет данных для отображения, пожалуйста обновите данные",
              true);
        }
            : () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MainPage(type: DataType.shimont),
            ),
          );
        },
        name: 'Шиномонтаж',
        image: SvgPicture.asset('lib/assets/tire.svg'),
      ),
      ServiceCard(
        onTap: isCarWashingEmpty
            ? () => {
          SnackBarService.showSnackBar(
              context,
              "Нет данных для отображения, пожалуйста обновите данные",
              true)
        }
            : () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                  const MainPage(type: DataType.carWashing)))
        },
        name: 'Мойки',
        image: SvgPicture.asset('lib/assets/car-wash.svg'),
      ),
      ServiceCard(
        onTap: () {
          Navigator.pushNamed(context, ContactPage.routeName);
        },
        name: 'Контакты',
        image: SvgPicture.asset('lib/assets/contact-mail.svg'),
      ),
      ServiceCard(
        onTap: () {
          Navigator.pushNamed(context, PromoPage.routeName);
        },
        name: 'Промо',
        image: SvgPicture.asset('lib/assets/hot-sale.svg'),
      ),
    ];

    return cards[index];
  }
}
