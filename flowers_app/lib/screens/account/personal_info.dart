import 'package:flowers_app/screens/account/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:flowers_app/rest_api/rest_api_auth.dart';
import 'package:flowers_app/components/navigation_bar.dart';

class PersonalInfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PersonalInfoScreenState();
}

class PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _phoneTextController = TextEditingController();

  dynamic _userData;
  bool _isLoaded = false;

  Widget _getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      primary: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: Color(0xFFB1ADAD),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 5.5,
        ),
        width: MediaQuery.of(context).size.width / 3.3,
        alignment: Alignment.center,
        child: Center(
          child: Text(
            'Обо мне',
            style: TextStyle(
              fontSize: 25,
              color: Color(0xFFB1ADAD),
              fontFamily: 'Book Antiqua',
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration(labelText) {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blueAccent,
        ),
      ),
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.blueAccent,
      ),
      errorStyle: TextStyle(
        color: Colors.redAccent,
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.redAccent,
        ),
      ),
    );
  }

  Future<void> _fetchUserData() async {
    _userData = await AuthService.getUserInfo();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData().then((result) {
      setState(() {
        _isLoaded = true;
      });
    });
  }

  _edit(BuildContext context) async {
    var validateRes = _formKey.currentState.validate();
    if (!validateRes) {
      return;
    }

    final editRes = await AuthService.performEdit(
      name: _nameTextController.text,
      email: _emailTextController.text,
      phone: _phoneTextController.text,
      password: _userData["password"],
    );

    if (!editRes) {
      Alert(
        context: context,
        title: "Произошла ошибка при сохранении изменений. Попробуйте еще раз.",
        buttons: [
          DialogButton(
            child: Text(
              "Ок",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFFFFFFF),
                fontFamily: 'Book Antiqua',
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ).show();
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AccountScreen(),
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    if (!_isLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    _nameTextController.text = _userData["name"];
    _emailTextController.text = _userData["email"];
    _phoneTextController.text = _userData["phone"];

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Container(
          margin: EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
          ),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameTextController,
                validator: RequiredValidator(
                  errorText: "Это поле обязательно к заполнению",
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF828282),
                  fontFamily: 'Book Antiqua',
                ),
                decoration: _getInputDecoration("Ваше имя"),
              ),
              TextFormField(
                controller: _emailTextController,
                validator: MultiValidator(
                  [
                    EmailValidator(
                        errorText: "Вы ввели неверный почтовый адрес"),
                    RequiredValidator(
                      errorText: "Это поле обязательно к заполнению",
                    ),
                  ],
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF828282),
                  fontFamily: 'Book Antiqua',
                ),
                decoration: _getInputDecoration("Ваша почта"),
              ),
              TextFormField(
                controller: _phoneTextController,
                validator: MultiValidator(
                  [
                    RequiredValidator(
                      errorText: "Это поле обязательно к заполнению",
                    ),
                  ],
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF828282),
                  fontFamily: 'Book Antiqua',
                ),
                decoration: _getInputDecoration("Ваш телефон"),
              ),
              RaisedButton(
                color: Color(0xFFC9C9C9),
                onPressed: () => _edit(context),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.9,
                  alignment: Alignment.center,
                  child: Text(
                    'Сохранить изменения',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFFFFFFF),
                      fontFamily: 'Book Antiqua Bold',
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 1.2,
                child: Center(
                  child: Text(
                    'при подтверждении заказы, вы соглашаетесь с \nПолитикой конфиденциальности и с условиями публичной офертой',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF111111),
                      fontFamily: 'Book Antiqua',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBFF),
      appBar: _getAppBar(context),
      bottomNavigationBar: getNavigationBar(context),
      body: _getBodyWidget(context),
    );
  }
}
