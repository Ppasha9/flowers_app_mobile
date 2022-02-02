import 'package:bottom_loader/bottom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/auth_controller.dart';
import 'package:orlove_app/models/cart_model.dart';
import 'package:orlove_app/models/favorites_model.dart';
import 'package:orlove_app/screens/components/bottom_loader.dart';
import 'package:orlove_app/screens/home/home_screen.dart';
import 'package:orlove_app/screens/signup/signup_screen.dart';
import 'package:orlove_app/utils/utils.dart';
import 'package:provider/provider.dart';

class SignInInputForms extends StatefulWidget {
  @override
  _SignInInputFormsState createState() => _SignInInputFormsState();
}

class _SignInInputFormsState extends State<SignInInputForms> {
  BottomLoader bottomLoader;

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
        labelText: 'Почта или номер телефона*',
        labelStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
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
        labelText: 'Пароль*',
        labelStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
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

  _login(
    BuildContext context,
    CartModel cartModel,
    FavoritesModel favoritesModel,
  ) async {
    var validateRes = _formKey.currentState.validate();
    if (!validateRes) {
      if (bottomLoader.isShowing()) {
        bottomLoader.close();
      }
      return;
    }

    if (!bottomLoader.isShowing()) {
      bottomLoader.display();
    }

    var authRes = await AuthController.performLogin(
      _emailTextController.text,
      _passwordTextController.text,
    );

    if (!authRes) {
      if (bottomLoader.isShowing()) {
        bottomLoader.close();
      }

      return Fluttertoast.showToast(
        msg: "Неверный логин или пароль",
        fontSize: 16,
      );
    }

    await cartModel.updateCartFullInfo();
    await favoritesModel.init();

    if (bottomLoader.isShowing()) {
      bottomLoader.close();
    }

    return Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (_) => HomeScreen(),
      ),
    );
  }

  Widget _getButtonWidget(
    MediaQueryData mediaQuery,
    CartModel cartModel,
    FavoritesModel favoritesModel,
  ) {
    return Center(
      child: GestureDetector(
        onTap: () => _login(
          context,
          cartModel,
          favoritesModel,
        ),
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
                color: ProjectConstants.BUTTON_TEXT_COLOR,
              ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
            color: ProjectConstants.BUTTON_BACKGROUND_COLOR,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bottomLoader = getBottomLoader(context);
    CartModel cartModel = context.watch<CartModel>();
    FavoritesModel favoritesModel = context.watch<FavoritesModel>();

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
            _getButtonWidget(
              mediaQuery,
              cartModel,
              favoritesModel,
            ),
            SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => SignupScreen(),
                  ),
                );
              },
              child: Center(
                child: Text(
                  'Зарегистрироваться',
                  style: TextStyle(
                    color: ProjectConstants.APP_FONT_COLOR,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontSize: 18 * mediaQuery.textScaleFactor,
                    fontWeight: FontWeight.w600,
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
