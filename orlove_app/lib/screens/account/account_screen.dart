import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/screens/account/account_contacts_screen.dart';
import 'package:orlove_app/screens/account/account_password_change_screen.dart';
import 'package:orlove_app/screens/account/account_personal_info.dart';
import 'package:orlove_app/screens/account/orders/orders_screen.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/screens/components/social_buttons.dart';
import 'package:orlove_app/screens/home/home_screen.dart';
import 'package:orlove_app/screens/signin/signin_screen.dart';
import 'package:orlove_app/storage/storage.dart';

class AccountScreen extends StatelessWidget {
  Future _logout(BuildContext context) async {
    if (!SecureStorage.isLogged) {
      Fluttertoast.showToast(
        msg: "Сначала войдите в аккаунт",
        fontSize: 16.0,
      );
      return;
    }

    return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: Text("Вы уверены?"),
          actions: [
            CupertinoDialogAction(
              child: Text("Нет"),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text("Выйти"),
              onPressed: () {
                SecureStorage.isLogged = false;
                Navigator.of(ctx).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (_) => HomeScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Профиль",
                style: TextStyle(
                  fontSize: 20 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  fontWeight: FontWeight.w600,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!SecureStorage.isLogged) {
                        Fluttertoast.showToast(
                          msg: "Сначала войдите в аккаунт",
                          fontSize: 16.0,
                        );
                        return;
                      }

                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => OrdersScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: mediaQuery.size.width * 0.40,
                      height: mediaQuery.size.height * 0.15,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ProjectConstants.DEFAULT_STROKE_COLOR,
                          width: 0.3,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list_alt_rounded,
                            color: ProjectConstants.APP_FONT_COLOR,
                            size: 30.0,
                          ),
                          Text(
                            "Заказы и возврат",
                            style: TextStyle(
                              fontSize: 14 * mediaQuery.textScaleFactor,
                              fontFamily: ProjectConstants.APP_FONT_FAMILY,
                              fontWeight: FontWeight.w600,
                              color: ProjectConstants.APP_FONT_COLOR,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: mediaQuery.size.width * 0.40,
                    height: mediaQuery.size.height * 0.15,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ProjectConstants.DEFAULT_STROKE_COLOR,
                        width: 0.3,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wallet_giftcard_rounded,
                          color: ProjectConstants.APP_FONT_COLOR,
                          size: 30.0,
                        ),
                        Text(
                          "Бонусы",
                          style: TextStyle(
                            fontSize: 14 * mediaQuery.textScaleFactor,
                            fontFamily: ProjectConstants.APP_FONT_FAMILY,
                            fontWeight: FontWeight.w600,
                            color: ProjectConstants.APP_FONT_COLOR,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!SecureStorage.isLogged) {
                        Fluttertoast.showToast(
                          msg: "Сначала войдите в аккаунт",
                          fontSize: 16.0,
                        );
                        return;
                      }

                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => AccountPersonalInfoScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: mediaQuery.size.width * 0.40,
                      height: mediaQuery.size.height * 0.15,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ProjectConstants.DEFAULT_STROKE_COLOR,
                          width: 0.3,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_box_outlined,
                            color: ProjectConstants.APP_FONT_COLOR,
                            size: 30.0,
                          ),
                          Text(
                            "Личные данные",
                            style: TextStyle(
                              fontSize: 14 * mediaQuery.textScaleFactor,
                              fontFamily: ProjectConstants.APP_FONT_FAMILY,
                              fontWeight: FontWeight.w600,
                              color: ProjectConstants.APP_FONT_COLOR,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!SecureStorage.isLogged) {
                        Fluttertoast.showToast(
                          msg: "Сначала войдите в аккаунт",
                          fontSize: 16.0,
                        );
                        return;
                      }

                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => AccountPasswordChangeScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: mediaQuery.size.width * 0.40,
                      height: mediaQuery.size.height * 0.15,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ProjectConstants.DEFAULT_STROKE_COLOR,
                          width: 0.3,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.vpn_key_outlined,
                            color: ProjectConstants.APP_FONT_COLOR,
                            size: 30.0,
                          ),
                          Text(
                            "Изменить пароль",
                            style: TextStyle(
                              fontSize: 14 * mediaQuery.textScaleFactor,
                              fontFamily: ProjectConstants.APP_FONT_FAMILY,
                              fontWeight: FontWeight.w600,
                              color: ProjectConstants.APP_FONT_COLOR,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Text(
                "Напишите нам",
                style: TextStyle(
                  fontSize: 20 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            SocialButtonsWidget(),
            SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Вопрос-ответ",
                      style: TextStyle(
                        fontSize: 16 * mediaQuery.textScaleFactor,
                        fontFamily: ProjectConstants.APP_FONT_FAMILY,
                        color: ProjectConstants.APP_FONT_COLOR,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 2.5,
            ),
            Divider(
              color: ProjectConstants.DEFAULT_STROKE_COLOR,
              thickness: 0.3,
              indent: 15,
              endIndent: 15,
            ),
            SizedBox(
              height: 2.5,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Отзывы",
                      style: TextStyle(
                        fontSize: 16 * mediaQuery.textScaleFactor,
                        fontFamily: ProjectConstants.APP_FONT_FAMILY,
                        color: ProjectConstants.APP_FONT_COLOR,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 2.5,
            ),
            Divider(
              color: ProjectConstants.DEFAULT_STROKE_COLOR,
              thickness: 0.3,
              indent: 15,
              endIndent: 15,
            ),
            SizedBox(
              height: 2.5,
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => AccountContactsScreen(),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Контакты",
                      style: TextStyle(
                        fontSize: 16 * mediaQuery.textScaleFactor,
                        fontFamily: ProjectConstants.APP_FONT_FAMILY,
                        color: ProjectConstants.APP_FONT_COLOR,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 2.5,
            ),
            Divider(
              color: ProjectConstants.DEFAULT_STROKE_COLOR,
              thickness: 0.3,
              indent: 15,
              endIndent: 15,
            ),
            SizedBox(
              height: 2.5,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "О компании",
                      style: TextStyle(
                        fontSize: 16 * mediaQuery.textScaleFactor,
                        fontFamily: ProjectConstants.APP_FONT_FAMILY,
                        color: ProjectConstants.APP_FONT_COLOR,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 2.5,
            ),
            Divider(
              color: ProjectConstants.DEFAULT_STROKE_COLOR,
              thickness: 0.3,
              indent: 15,
              endIndent: 15,
            ),
            SizedBox(
              height: 2.5,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Оценить приложение",
                      style: TextStyle(
                        fontSize: 16 * mediaQuery.textScaleFactor,
                        fontFamily: ProjectConstants.APP_FONT_FAMILY,
                        color: ProjectConstants.APP_FONT_COLOR,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 2.5,
            ),
            Divider(
              color: ProjectConstants.DEFAULT_STROKE_COLOR,
              thickness: 0.3,
              indent: 15,
              endIndent: 15,
            ),
            SizedBox(
              height: 2.5,
            ),
            GestureDetector(
              onTap: () => _logout(context),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Выйти",
                      style: TextStyle(
                        fontSize: 16 * mediaQuery.textScaleFactor,
                        fontFamily: ProjectConstants.APP_FONT_FAMILY,
                        color: ProjectConstants.APP_FONT_COLOR,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSigninButton(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (!SecureStorage.isLogged) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => SignInScreen(),
            ),
          );
        },
        child: Center(
          child: Container(
            height: 50,
            width: mediaQuery.size.width / 1.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(1.0)),
              color: ProjectConstants.BUTTON_BACKGROUND_COLOR,
            ),
            child: Center(
              child: Text(
                "Войти/зарегистрироваться",
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
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      body: _getBodyWidget(context),
      appBar: getAppBar(context),
      bottomNavigationBar: SecureStorage.isLogged
          ? getBottomNavigationBar(
              context,
              isAccount: true,
            )
          : Container(
              height: 163,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: _getSigninButton(context),
                  ),
                  getBottomNavigationBar(
                    context,
                    isAccount: true,
                  ),
                ],
              ),
            ),
    );
  }
}
