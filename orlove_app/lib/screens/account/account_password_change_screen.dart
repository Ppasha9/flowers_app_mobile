import 'package:bottom_loader/bottom_loader.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/auth_controller.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_loader.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/storage/storage.dart';

class AccountPasswordChangeScreen extends StatefulWidget {
  @override
  _AccountPasswordChangeScreenState createState() =>
      _AccountPasswordChangeScreenState();
}

class _AccountPasswordChangeScreenState
    extends State<AccountPasswordChangeScreen> {
  BottomLoader bottomLoader;

  final _formKey = GlobalKey<FormState>();

  final _newPasswordTextController = TextEditingController();
  final _newPasswordAgainTextController = TextEditingController();

  Widget _getNewPassInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _newPasswordTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Введите новый пароль*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
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
      ),
      validator: RequiredValidator(
        errorText: "Это поле обязательно к заполнению",
      ),
    );
  }

  Widget _getNewPassAgainInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _newPasswordAgainTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Повторите новый пароль*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
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
      ),
      validator: (value) {
        if (value != _newPasswordTextController.text) {
          return "Пароли не совпадают";
        }

        return null;
      },
    );
  }

  Future _onConfirmButtonPressed(BuildContext context) async {
    if (!bottomLoader.isShowing()) {
      bottomLoader.display();
    }

    final validateRes = _formKey.currentState.validate();
    if (!validateRes) {
      if (bottomLoader.isShowing()) {
        bottomLoader.close();
      }

      return;
    }

    var editRes = await AuthController.performEdit(
      email: SecureStorage.email,
      name: SecureStorage.name,
      surname: SecureStorage.surname,
      phone: SecureStorage.phone,
      password: _newPasswordTextController.text,
    );

    if (bottomLoader.isShowing()) {
      bottomLoader.close();
    }

    if (!editRes) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Внимание!"),
          content: Text("Произошла ошибка во время изменения личных данных."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text("Окей"),
            )
          ],
        ),
      );
      return;
    }

    Navigator.of(context).pop();
  }

  Widget _getBodyWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  width: mediaQuery.size.width,
                  child: Center(
                    child: Text(
                      "Изменение пароля",
                      style: TextStyle(
                        fontSize: 18 * mediaQuery.textScaleFactor,
                        fontFamily: ProjectConstants.APP_FONT_FAMILY,
                        fontWeight: FontWeight.w600,
                        color: ProjectConstants.APP_FONT_COLOR,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: ProjectConstants.APP_FONT_COLOR,
                      size: 35.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _getNewPassInputWidget(mediaQuery),
                  SizedBox(
                    height: 5.0,
                  ),
                  _getNewPassAgainInputWidget(mediaQuery),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () => _onConfirmButtonPressed(context),
              child: Center(
                child: Container(
                  height: 50,
                  width: mediaQuery.size.width / 1.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1.0)),
                    color: ProjectConstants.BUTTON_BACKGROUND_COLOR,
                  ),
                  child: Center(
                    child: Text(
                      "Сохранить",
                      style: TextStyle(
                        fontSize: 18 * mediaQuery.textScaleFactor,
                        fontFamily: ProjectConstants.APP_FONT_FAMILY,
                        color: ProjectConstants.BUTTON_TEXT_COLOR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bottomLoader = getBottomLoader(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
        body: _getBodyWidget(context),
        appBar: getAppBar(context),
        bottomNavigationBar: getBottomNavigationBar(context),
      ),
    );
  }
}
