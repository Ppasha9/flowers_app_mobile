import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/screens/signin/signin_input_forms.dart';

class SignInScreen extends StatelessWidget {
  Widget _getFacebookAuthButton(MediaQueryData mediaQuery) {
    return Container(
      width: mediaQuery.size.width * 0.90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 35,
            height: 35,
            child: Image.asset("assets/images/facebook_icon.png"),
            margin: const EdgeInsets.only(
              right: 10,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              width: mediaQuery.size.width * 0.70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1.0)),
                border: Border.all(
                  color: ProjectConstants.DEFAULT_STROKE_COLOR,
                ),
              ),
              child: Center(
                child: Text(
                  'Войти через Facebook',
                  style: TextStyle(
                    fontSize: 18 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontWeight: FontWeight.w600,
                    color: ProjectConstants.APP_FONT_COLOR,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getGoogleAuthButton(MediaQueryData mediaQuery) {
    return Container(
      width: mediaQuery.size.width * 0.90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 35,
            height: 35,
            child: Image.asset("assets/images/google_icon.png"),
            margin: const EdgeInsets.only(
              right: 10,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              width: mediaQuery.size.width * 0.70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1.0)),
                border: Border.all(
                  color: ProjectConstants.DEFAULT_STROKE_COLOR,
                ),
              ),
              child: Center(
                child: Text(
                  'Войти через Google',
                  style: TextStyle(
                    fontSize: 18 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontWeight: FontWeight.w600,
                    color: ProjectConstants.APP_FONT_COLOR,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCenterSeparator(MediaQueryData mediaQuery) {
    return Container(
      child: Row(
        children: [
          Container(
            width: mediaQuery.size.width * 0.44,
            child: const Divider(
              color: ProjectConstants.APP_FONT_COLOR,
              height: 25.0,
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
          ),
          Text(
            'или',
            style: TextStyle(
              fontSize: 18 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              fontWeight: FontWeight.w600,
              color: ProjectConstants.APP_FONT_COLOR,
            ),
          ),
          Container(
            width: mediaQuery.size.width * 0.44,
            child: Divider(
              color: ProjectConstants.APP_FONT_COLOR,
              height: 25.0,
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Container(
        width: mediaQuery.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Войдите в аккаунт',
              style: TextStyle(
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                fontSize: 24 * mediaQuery.textScaleFactor,
                fontWeight: FontWeight.bold,
                color: ProjectConstants.APP_FONT_COLOR,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            _getFacebookAuthButton(mediaQuery),
            const SizedBox(
              height: 10,
            ),
            _getGoogleAuthButton(mediaQuery),
            const SizedBox(
              height: 60,
            ),
            _getCenterSeparator(mediaQuery),
            const SizedBox(
              height: 60,
            ),
            SignInInputForms(),
          ],
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
        body: _getBodyWidget(context),
      ),
    );
  }
}
