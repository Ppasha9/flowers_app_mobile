import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:orlove_app/constants.dart';

class SignInInputForms extends StatefulWidget {
  @override
  _SignInInputFormsState createState() => _SignInInputFormsState();
}

class _SignInInputFormsState extends State<SignInInputForms> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  Widget _getEmailInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      controller: _emailTextController,
      style: TextStyle(
        color: Color(0xFFAEAEAE),
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 13 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: 'Почта или номер телефона',
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

  Widget _getPasswordInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      controller: _passwordTextController,
      style: TextStyle(
        color: Color(0xFFAEAEAE),
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 13 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Пароль',
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
              'Войти',
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      width: mediaQuery.size.width * 0.80,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _getEmailInputWidget(mediaQuery),
            SizedBox(
              height: 15,
            ),
            _getPasswordInputWidget(mediaQuery),
            SizedBox(
              height: 35,
            ),
            _getButtonWidget(mediaQuery),
            SizedBox(
              height: 45,
            ),
            GestureDetector(
              onTap: () {},
              child: Center(
                child: Text(
                  'Зарегистрироваться',
                  style: TextStyle(
                    color: ProjectConstants.APP_FONT_COLOR,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontSize: 24 * mediaQuery.textScaleFactor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
