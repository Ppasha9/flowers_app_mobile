import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/screens/signin/signin_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _surnameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _passwordAgainTextController = TextEditingController();

  Widget _getNameInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _nameTextController,
      style: TextStyle(
        color: Color(0xFFAEAEAE),
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 13 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: 'Имя*',
        labelStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.redAccent,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
      validator: RequiredValidator(
        errorText: "Это поле обязательно к заполнению",
      ),
    );
  }

  Widget _getSurnameInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _surnameTextController,
      style: TextStyle(
        color: Color(0xFFAEAEAE),
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 13 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: 'Фамилия*',
        labelStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.redAccent,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
      validator: RequiredValidator(
        errorText: "Это поле обязательно к заполнению",
      ),
    );
  }

  Widget _getEmailInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextController,
      style: TextStyle(
        color: Color(0xFFAEAEAE),
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 13 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: 'Почта*',
        labelStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.redAccent,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
      validator: MultiValidator(
        [
          RequiredValidator(
            errorText: "Это поле обязательно к заполнению",
          ),
          EmailValidator(
            errorText: "Вы ввели неверный почтовый адрес",
          ),
        ],
      ),
    );
  }

  Widget _getPhoneInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: _phoneTextController,
      style: TextStyle(
        color: Color(0xFFAEAEAE),
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 13 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: 'Контактный телефон*',
        labelStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.redAccent,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
      validator: RequiredValidator(
        errorText: "Это поле обязательно к заполнению",
      ),
    );
  }

  Widget _getPasswordInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextController,
      style: TextStyle(
        color: Color(0xFFAEAEAE),
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 13 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: 'Пароль*',
        labelStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.redAccent,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
      validator: MultiValidator(
        [
          RequiredValidator(
            errorText: "Это поле обязательно к заполнению",
          ),
          MinLengthValidator(6,
              errorText: "Пароль должен быть не менее 6 символов"),
        ],
      ),
    );
  }

  Widget _getPasswordAgainInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordAgainTextController,
      style: TextStyle(
        color: Color(0xFFAEAEAE),
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 13 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: 'Повторите пароль*',
        labelStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.redAccent,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
      validator: MultiValidator(
        [
          RequiredValidator(
            errorText: "Это поле обязательно к заполнению",
          ),
          MinLengthValidator(6,
              errorText: "Пароль должен быть не менее 6 символов"),
        ],
      ),
    );
  }

  Widget _getButtonWidget(MediaQueryData mediaQuery) {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: mediaQuery.size.width * 0.80,
          height: 45.0,
          child: Center(
            child: Text(
              'Зарегистрироваться',
              style: TextStyle(
                fontSize: 18 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD73534),
              ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
            color: Color(0xFFFFB9C2),
          ),
        ),
      ),
    );
  }

  Widget _getBodyWidget(MediaQueryData mediaQuery) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Center(
          child: Container(
            width: mediaQuery.size.width * 0.90,
            margin: const EdgeInsets.only(top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Регистрация',
                  style: TextStyle(
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontSize: 24 * mediaQuery.textScaleFactor,
                    fontWeight: FontWeight.bold,
                    color: ProjectConstants.APP_FONT_COLOR,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _getNameInputWidget(mediaQuery),
                SizedBox(
                  height: 10,
                ),
                _getSurnameInputWidget(mediaQuery),
                SizedBox(
                  height: 10,
                ),
                _getEmailInputWidget(mediaQuery),
                SizedBox(
                  height: 10,
                ),
                _getPhoneInputWidget(mediaQuery),
                SizedBox(
                  height: 10,
                ),
                _getPasswordInputWidget(mediaQuery),
                SizedBox(
                  height: 10,
                ),
                _getPasswordAgainInputWidget(mediaQuery),
                SizedBox(
                  height: 15,
                ),
                _getButtonWidget(mediaQuery),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Уже зарегистрированы?',
                      style: TextStyle(
                        fontFamily: ProjectConstants.APP_FONT_FAMILY,
                        fontSize: 20 * mediaQuery.textScaleFactor,
                        color: ProjectConstants.APP_FONT_COLOR,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => SignInScreen(),
                        ),
                      ),
                      child: Text(
                        'Вход',
                        style: TextStyle(
                          fontFamily: ProjectConstants.APP_FONT_FAMILY,
                          fontSize: 20 * mediaQuery.textScaleFactor,
                          color: ProjectConstants.APP_FONT_COLOR,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    "при подтверждении заказы, вы соглашаетесь с\nПолитикой конфиденциальности и с условиями публичной офертой",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      fontSize: 10 * mediaQuery.textScaleFactor,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: ProjectConstants.APP_FONT_COLOR,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
        body: _getBodyWidget(MediaQuery.of(context)),
      ),
    );
  }
}
