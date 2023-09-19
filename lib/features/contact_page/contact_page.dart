import 'package:flutter/material.dart';
import 'package:liga_shin_test/features/services/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../style/style_library.dart';

class ContactPage extends StatelessWidget {
  static const routeName = '/contactPage';

  const ContactPage({super.key});

  void _makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _sendEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    final urlString = emailLaunchUri.toString();
    if (await canLaunchUrl(Uri.parse(urlString))) {
      await launchUrl(Uri.parse(urlString));
    } else {
      throw 'Could not launch $urlString';
    }
  }

  void _openWebsite(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Контакты',
          style: StyleLibrary.text.black16,
        ),
        backgroundColor: const Color(0xffDEC746),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                alignment: Alignment.center,
                child: const Text(
                  'Свяжитесь с нами любым удобным для Вас способом',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(flex: 2, child: Icon(Icons.phone)),
                            Expanded(
                              flex: 4,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: const Text(
                                  'Телефон',
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    _makePhoneCall(Constants.companyPhone);
                                  },
                                  child: const Text(
                                    Constants.companyPhone,
                                    style: TextStyle(
                                        color: Colors.red,
                                        decoration: TextDecoration.underline,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Icon(Icons.email)),
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: const Text(
                                  'Email',
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _sendEmail(Constants.companyMail);
                                      },
                                      child: const Text(
                                        Constants.companyMail,
                                        style: TextStyle(
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 15),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _sendEmail(Constants.secondCompanyMail);
                                      },
                                      child: const Text(
                                        Constants.secondCompanyMail,
                                        style: TextStyle(
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 2, child: Icon(Icons.map)),
                            Expanded(
                              flex: 4,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: const Text(
                                  'Адрес',
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: const Text(
                                    Constants.address,
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex: 2, child: Icon(Icons.public)),
                            Expanded(
                              flex: 4,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: const Text(
                                  'Сайт',
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    _openWebsite(Constants.webSiteAddress);
                                  },
                                  child: const Text(
                                    Constants.webSiteAddress,
                                    style: TextStyle(
                                        color: Colors.red,
                                        decoration: TextDecoration.underline,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
