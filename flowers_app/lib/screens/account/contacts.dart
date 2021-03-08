import 'package:flowers_app/components/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
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
            'Контакты',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBFF),
      appBar: _getAppBar(context),
      bottomNavigationBar: getNavigationBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 10.0,
                left: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Телефон',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFB1ADAD),
                      fontFamily: 'Book Antiqua Bold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '+7 (911) 000-34-56',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFB1ADAD),
                      fontFamily: 'Book Antiqua',
                    ),
                  ),
                  Text(
                    'Эл. почта',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFB1ADAD),
                      fontFamily: 'Book Antiqua Bold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'lavanda@thebest.ru',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFB1ADAD),
                      fontFamily: 'Book Antiqua',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Напишите нам',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFB1ADAD),
                  fontFamily: 'Book Antiqua Bold',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                          "assets/images/product_screen/whatsapp.png"),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Container(
                      alignment: Alignment.center,
                      child:
                          Image.asset("assets/images/product_screen/email.png"),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                          "assets/images/product_screen/telegram.png"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
