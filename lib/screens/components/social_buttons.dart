import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';

class SocialButtonsWidget extends StatelessWidget {
  Widget _getSocialButtonWidget(
      String imageAssetPath, String label, MediaQueryData mediaQuery) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(
          5.0,
        ),
        height: 40.0,
        width: mediaQuery.size.width / 3.3,
        decoration: BoxDecoration(
          border: Border.all(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                right: 5.0,
              ),
              height: 20.0,
              width: 20.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imageAssetPath),
                ),
              ),
            ),
            Text(
              label,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Row(
      children: [
        _getSocialButtonWidget(
          "assets/images/whatsapp_icon.png",
          "WhatsApp",
          mediaQuery,
        ),
        _getSocialButtonWidget(
          "assets/images/email_icon.png",
          "Эл. почта",
          mediaQuery,
        ),
        _getSocialButtonWidget(
          "assets/images/telegram_icon.png",
          "Telegram",
          mediaQuery,
        ),
      ],
    );
  }
}
