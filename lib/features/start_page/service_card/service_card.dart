import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../style/style_library.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard(
      {Key? key, required this.onTap, required this.name, required this.image})
      : super(key: key);

  final Function() onTap;
  final String name;
  final SvgPicture image;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: StyleLibrary.button.defaultButton,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            image,
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FittedBox(
                child: Text(
                  name,
                  style: StyleLibrary.text.black20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}