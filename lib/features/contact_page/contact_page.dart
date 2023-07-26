import 'package:flutter/material.dart';
import 'package:liga_shin_test/features/services/constants.dart';
import 'package:url_launcher/url_launcher.dart';

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
        backgroundColor: Colors.lime,
        title: const Text(
          "Контакты",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
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
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Table(
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  children: [
                    TableRow(
                      children: [
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Icon(Icons.phone),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Text(
                              'Телефон',
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
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
                    TableRow(
                      children: [
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Icon(Icons.email),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: const Text(
                              'Email',
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
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
                                        decoration: TextDecoration.underline,
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
                                        decoration: TextDecoration.underline,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Icon(Icons.map),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: const Text(
                              'Адрес',
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: const Text(
                                Constants.address,
                                style: TextStyle(fontSize: 15),
                              )),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Icon(Icons.public),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: const Text(
                              'Сайт',
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
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
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
