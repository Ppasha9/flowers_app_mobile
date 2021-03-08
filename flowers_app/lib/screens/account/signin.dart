import 'package:flowers_app/rest_api/rest_api_auth.dart';
import 'package:flowers_app/screens/account/account.dart';
import 'package:flowers_app/screens/account/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  Future<bool> _checkIsLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogged");
  }

  @override
  void initState() {
    super.initState();
    _checkIsLogged().then((value) {
      if (value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AccountScreen(),
          ),
        );
      }
    });
  }

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
        controller: _passwordTextController,
        obscureText: true,
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
            Icons.lock_outline,
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

  _login(BuildContext context) async {
    var validateRes = _formKey.currentState.validate();
    if (!validateRes) {
      return;
    }

    var authRes = await AuthService.performLogin(
      email: _emailTextController.text,
      password: _passwordTextController.text,
    );
    if (!authRes) {
      Alert(
        context: context,
        title: "Произошла ошибка при авторизации. Попробуйте еще раз.",
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10.0, top: 20.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFFFFFFFF),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 6,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.3,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFBFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 30.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Войдите в аккаунт',
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xFF6B6B6B),
                          fontFamily: 'Book Antiqua',
                        ),
                      ),
                    ),
                    _getInputTextAreaWidget(
                      context,
                      _getEmailTextWidget(context),
                    ),
                    _getInputTextAreaWidget(
                      context,
                      _getPasswordTextWidget(context),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30.0),
                      child: RaisedButton(
                        color: Color(0xFFC9C9C9),
                        onPressed: () => _login(context),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          alignment: Alignment.center,
                          child: Text(
                            'Войти',
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
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width / 2.05,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text("f"),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFF2F2F2),
                                onPrimary: Colors.black,
                                shape: CircleBorder(),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width / 2.05,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text("g+"),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFF2F2F2),
                                onPrimary: Colors.black,
                                shape: CircleBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40.0),
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Зарегистрироваться',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF6B6B6B),
                            fontFamily: 'Book Antiqua Bold',
                          ),
                        ),
                      ),
                    )
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
