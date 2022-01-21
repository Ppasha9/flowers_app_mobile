import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/screens/signin/signin_input_forms.dart';

class SignInScreen extends StatelessWidget {
  // Future _onGoogleSignIn(BuildContext context) async {
  //   GoogleSignIn googleSignIn = GoogleSignIn(
  //     scopes: [
  //       "email",
  //     ],
  //   );

  //   googleSignIn.signIn().then((GoogleSignInAccount acc) async {
  //     GoogleSignInAuthentication auth = await acc.authentication;

  //     print(acc.id);
  //     print(acc.email);
  //     print(acc.displayName);
  //     print(acc.photoUrl);

  //     acc.authentication.then((GoogleSignInAuthentication auth) {
  //       print(auth.accessToken);
  //       print(auth.idToken);
  //     });
  //   }).catchError((err) {
  //     return showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //         title: Text("Произошла ошибка при авторизации!"),
  //         content: Text("Неизвестная ошибка"),
  //         actions: [
  //           TextButton(
  //             child: Text("Окей"),
  //             onPressed: () {
  //               Navigator.of(ctx).pop();
  //             },
  //           ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  Widget _getGoogleAuthButton(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      //onTap: () => _onGoogleSignIn(context),
      onTap: () {},
      child: Container(
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
            Container(
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
                    fontSize: 16 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontWeight: FontWeight.w600,
                    color: ProjectConstants.APP_FONT_COLOR,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCenterSeparator(MediaQueryData mediaQuery) {
    return Container(
      width: mediaQuery.size.width * 0.80,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: mediaQuery.size.width * 0.3,
              child: const Divider(
                color: ProjectConstants.APP_FONT_COLOR,
                thickness: 0.3,
                endIndent: 10,
              ),
            ),
            Text(
              'OR',
              style: TextStyle(
                fontSize: 18 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                fontWeight: FontWeight.normal,
                color: ProjectConstants.APP_FONT_COLOR,
              ),
            ),
            Icon(
              Icons.favorite,
              color: Color(0xFFFFB9C2),
              size: 20.0,
            ),
            Container(
              width: mediaQuery.size.width * 0.3,
              child: Divider(
                color: ProjectConstants.APP_FONT_COLOR,
                thickness: 0.3,
                indent: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context, double appBarHeight) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Center(
        child: Container(
          height: mediaQuery.size.height - kToolbarHeight * 2 - appBarHeight,
          width: mediaQuery.size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Войдите в аккаунт',
                style: TextStyle(
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  fontSize: 20 * mediaQuery.textScaleFactor,
                  fontWeight: FontWeight.w600,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SignInInputForms(),
              const SizedBox(
                height: 60,
              ),
              _getCenterSeparator(mediaQuery),
              const SizedBox(
                height: 60,
              ),
              _getGoogleAuthButton(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: ProjectConstants.APP_FONT_COLOR,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );

    return Scaffold(
      appBar: appBar,
      backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      body: _getBodyWidget(context, appBar.preferredSize.height),
    );
  }
}
