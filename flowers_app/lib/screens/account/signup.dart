import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'signin.dart';
import 'account.dart';
import 'package:flowers_app/rest_api/rest_api_auth.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passSecondTextController = TextEditingController();

  InputDecoration _getInputDecoration({hint, icon: null}) {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blueAccent,
        ),
      ),
      hintText: hint,
      icon: icon,
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

  Widget _getTextWidget(BuildContext context, String hintText,
      TextEditingController controller, IconData iconData) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.4,
      height: MediaQuery.of(context).size.height / 15,
      child: TextFormField(
        controller: controller,
        validator:
            RequiredValidator(errorText: "Это поле обязательно к заполнению"),
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFF828282),
          fontFamily: 'Book Antiqua',
        ),
        decoration: _getInputDecoration(
          hint: hintText,
          icon: Icon(
            iconData,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _getEmailTextWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.4,
      height: MediaQuery.of(context).size.height / 15,
      child: TextFormField(
        controller: _emailTextController,
        validator: MultiValidator(
          [
            RequiredValidator(errorText: "Это поле обязательно к заполнению"),
            EmailValidator(errorText: "Вы ввели неверный почтовый адрес"),
          ],
        ),
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFF828282),
          fontFamily: 'Book Antiqua',
        ),
        decoration: _getInputDecoration(
          hint: 'Введите почту',
          icon: Icon(
            Icons.email,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _getPasswordTextWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.4,
      height: MediaQuery.of(context).size.height / 15,
      child: TextFormField(
        obscureText: true,
        controller: _passTextController,
        validator: MultiValidator(
          [
            RequiredValidator(errorText: "Это поле обязательно к заполнению"),
            MinLengthValidator(6,
                errorText: "Пароль должен быть не менее 6 символов"),
          ],
        ),
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFF828282),
          fontFamily: 'Book Antiqua',
        ),
        decoration: _getInputDecoration(
          hint: 'Введите пароль',
          icon: Icon(
            Icons.badge,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _getPasswordSecondTextWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.4,
      height: MediaQuery.of(context).size.height / 15,
      child: TextFormField(
        obscureText: true,
        controller: _passSecondTextController,
        validator: (value) {
          if (value != _passTextController.text) {
            return "Пароли не совпадают!";
          }
          return null;
        },
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFF828282),
          fontFamily: 'Book Antiqua',
        ),
        decoration: _getInputDecoration(
          hint: 'Повторите пароль',
          icon: Icon(
            Icons.badge,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _getInputTextAreaWidget(BuildContext context, Widget childWidget) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.height / 12,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 40,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10.0,
          ),
        ],
      ),
      child: childWidget,
    );
  }

  _signup(BuildContext context) async {
    var validateRes = _formKey.currentState.validate();
    if (!validateRes) {
      return;
    }

    var authRes = await AuthService.performSignup(
      email: _emailTextController.text,
      password: _passTextController.text,
      phone: _phoneTextController.text,
      name: _nameTextController.text,
    );
    if (!authRes) {
      Alert(
        context: context,
        title: "Произошла ошибка при регистрации. Попробуйте еще раз.",
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
        builder: (BuildContext context) => AccountScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC9C9C9),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                  left: 10.0,
                  top: MediaQuery.of(context).size.height / 10,
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFFFFFFFF),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 8,
                      ),
                      child: Text(
                        'Регистрация',
                        style: TextStyle(
                          fontSize: 35,
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'Book Antiqua',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 35,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.145,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFBFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),
                    _getInputTextAreaWidget(
                      context,
                      _getTextWidget(context, "Введите имя",
                          _nameTextController, Icons.account_box),
                    ),
                    _getInputTextAreaWidget(
                      context,
                      _getEmailTextWidget(context),
                    ),
                    _getInputTextAreaWidget(
                      context,
                      _getTextWidget(context, "Введите контактный телефон",
                          _phoneTextController, Icons.phone_android),
                    ),
                    _getInputTextAreaWidget(
                      context,
                      _getPasswordTextWidget(context),
                    ),
                    _getInputTextAreaWidget(
                      context,
                      _getPasswordSecondTextWidget(context),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 45,
                      ),
                      child: RaisedButton(
                        color: Color(0xFFC9C9C9),
                        onPressed: () => _signup(context),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          alignment: Alignment.center,
                          child: Text(
                            'Зарегистрироваться',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFFFFFFF),
                              fontFamily: 'Book Antiqua Bold',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 45,
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => SigninScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Уже зарегистрированы? Вход.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF111111),
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
            ],
          ),
        ),
      ),
    );
  }
}
