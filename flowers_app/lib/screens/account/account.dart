import 'package:flowers_app/screens/account/contacts.dart';
import 'package:flowers_app/screens/account/orders.dart';
import 'package:flowers_app/screens/account/password_change.dart';
import 'package:flowers_app/screens/account/personal_info.dart';
import 'package:flowers_app/screens/account/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flowers_app/components/navigation_bar.dart';

class AccountScreen extends StatelessWidget {
  _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogged", false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => SigninScreen(),
      ),
    );
  }

  Widget _getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      primary: false,
      title: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 5.5,
        ),
        width: MediaQuery.of(context).size.width / 3.3,
        alignment: Alignment.center,
        child: Center(
          child: Text(
            'Профиль',
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

  Widget _getBoxButton(
      BuildContext context, IconData iconData, String text, callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.all(12.0),
        height: MediaQuery.of(context).size.height / 7.5,
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 10.0,
              color: Colors.grey,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.black,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFB1ADAD),
                fontFamily: 'Book Antiqua',
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getButton(BuildContext context, String text, callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Color(0xFFE5E5E5),
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFB1ADAD),
                  fontFamily: 'Book Antiqua Bold',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: 10.0,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFFB1ADAD),
              ),
            ),
          ],
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: _getBoxButton(
                      context,
                      Icons.list_alt_rounded,
                      "Заказы и возврат",
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrdersScreen(),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: _getBoxButton(
                      context,
                      Icons.wallet_giftcard,
                      "Бонусы",
                      () {},
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: _getBoxButton(
                      context,
                      Icons.account_box_sharp,
                      "Личные данные",
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PersonalInfoScreen(),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: _getBoxButton(
                      context,
                      Icons.vpn_key_outlined,
                      "Изменить пароль",
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PasswordChangeScreen(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            _getButton(
              context,
              'Отзывы',
              () {},
            ),
            _getButton(
              context,
              'Контакты',
              () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ContactsScreen(),
                ),
              ),
            ),
            _getButton(
              context,
              'О компании',
              () {},
            ),
            _getButton(
              context,
              'Выйти',
              () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
