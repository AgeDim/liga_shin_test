import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/data.dart';
import '../../style/style_library.dart';


class UpdateCard extends StatefulWidget {
  const UpdateCard({Key? key, required this.onTap}) : super(key: key);

  final Function() onTap;

  @override
  State<UpdateCard> createState() => _UpdateCardState();
}

class _UpdateCardState extends State<UpdateCard> {

  String updatedTime = '';

  @override
  void initState() {
    _setUpdTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          widget.onTap();
          _setUpdTime();
        },
        style: ButtonStyle(
          padding:
          MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(10)),
          backgroundColor: MaterialStateProperty.all<Color>(
              Colors.white),
          elevation: MaterialStateProperty.all<double>(0),
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              Ionicons.sync_outline,
              color: Colors.black,
              size: 40,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Обновить данные',
                    style: StyleLibrary.text.black14,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Данные от: ${_formatDate(updatedTime)}',
                      style: StyleLibrary.text.gray12,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _setUpdTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      updatedTime = prefs.getString(DataType.lastUpdate.name)!;
    });
  }

  String _formatDate(String dateStr) {
    if (dateStr != "") {
      final parsedDateTime = DateTime.parse(dateStr);
      final formatter = StyleLibrary.date.formatter;
      return formatter.format(parsedDateTime);
    }
    return "";
  }
}
