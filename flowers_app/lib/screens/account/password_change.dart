import 'package:flowers_app/components/navigation_bar.dart';
import 'package:flowers_app/rest_api/rest_api_auth.dart';
import 'package:flowers_app/screens/account/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PasswordChangeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PasswordChangeScreenState();
}

class PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _passTextController = TextEditingController();
  final _secondPassTextController = TextEditingController();

  bool _isLoaded = false;
  dynamic _userData;

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
        margin: EdgeInsets.only(
          right: MediaQuery.of(context).size.width / 7,
        ),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Center(
          child: Text(
            'Изменение пароля',
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

  InputDecoration _getInputDecoration(labelText, hintText) {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blueAccent,
        ),
      ),
      labelText: labelText,
      hintText: hintText,
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
    _fetchUserData().then((value) {
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
      name: _userData["name"],
      email: _userData["email"],
      phone: _userData["phone"],
      password: _passTextController.text,
    );

    if (!editRes) {
      Alert(
        context: context,
        title: "Произошла ошибка при изменении пароля. Попробуйте еще раз.",
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

    return SingleChildScrollView(
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Container(
          margin: EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
          ),
          child: Column(
            children: <Widget>[
              TextFormField(
                obscureText: true,
                controller: _passTextController,
                validator: RequiredValidator(
                  errorText: "Это поле обязательно к заполнению",
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF828282),
                  fontFamily: 'Book Antiqua',
                ),
                decoration: _getInputDecoration(
                  "Новый пароль",
                  "Введите новый пароль",
                ),
              ),
              TextFormField(
                obscureText: true,
                controller: _secondPassTextController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Это поле обязательно к заполнению";
                  } else if (value != _passTextController.text) {
                    return "Это поле должно совпадать с предыдущим";
                  }

                  return null;
                },
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF828282),
                  fontFamily: 'Book Antiqua',
                ),
                decoration: _getInputDecoration(
                  "Повторный новый пароль",
                  "Повторите новый пароль",
                ),
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
