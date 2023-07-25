import 'package:flutter/material.dart';

class PromoPage extends StatefulWidget {
  static const routeName = '/promoPage';

  const PromoPage({super.key});

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final phone = _phoneController.text;
      final email = _emailController.text;
      final carNumber = _carNumberController.text;

      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _carNumberController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime,
        title: const Text(
          "Промо",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: const Text(
                  'Скоро мы запустим бонусную программу для постоянных клиентов. Чтобы быть одним из первых оставьте, пожалуйста, свои контактные данные.',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 100, right: 15, left: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(labelText: 'Ваше Имя'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Пожалуйста введите ваше Имя';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Телефон',
                          prefix: Text('+7'),
                        ),
                        validator: (value) {
                          final phoneRegex = RegExp(r'^[1-9]\d{9}$');
                          if (!phoneRegex.hasMatch(value!)) {
                            return 'Пожалуйста введите корректный номер телефона';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Почта'),
                        validator: (value) {
                          final emailRegex = RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                          if (!emailRegex.hasMatch(value!)) {
                            return 'Пожалуйста введите корректный адрес вашей почты';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _carNumberController,
                        decoration:
                            const InputDecoration(labelText: 'Номер машины'),
                        validator: (value) {
                          final carNumberRegex = RegExp(
                              r'^[АВЕКМНОРСТУХABEKMHOPCTYX]\d{3}[АВЕКМНОРСТУХABEKMHOPCTYX]{2}\d{2,3}$');
                          if (!carNumberRegex.hasMatch(value!)) {
                            return 'Пожалуйста введите корректный номер вашей машины';
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Отправить'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
