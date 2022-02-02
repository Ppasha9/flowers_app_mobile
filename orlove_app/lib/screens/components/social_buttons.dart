import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class SocialButtonsWidget extends StatelessWidget {
  _openWhatsApp(BuildContext context) async {
    var snackBar = SnackBar(content: Text('Не удалось запустить Whatsapp'));

    final url = WhatsAppUnilink(
      phoneNumber: "+79112067131",
      text: "Привет!",
    );

    await canLaunch("$url")
        ? await launch("$url")
        : ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _openEmailApp(BuildContext context) async {
    var snackBar =
        SnackBar(content: Text('Не удалось запустить приложение эл. почты'));
    String url() {
      if (Platform.isIOS) {
        return "message:orlove-spb@mail.ru";
      } else {
        return "mailto:orlove-spb@mail.ru";
      }
    }

    await canLaunch(url())
        ? await launch(url())
        : ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _openTelegramApp(BuildContext context) async {
    var snackBar = SnackBar(content: Text('Не удалось запустить Telegram'));
    String url = "http://telegram.me/orloveflowers";

    await canLaunch(url)
        ? await launch(url)
        : ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _getSocialButtonWidget(String label, MediaQueryData mediaQuery,
      BuildContext context, onTapFunc) {
    return GestureDetector(
      onTap: () {
        onTapFunc(context);
      },
      child: Container(
        margin: const EdgeInsets.all(
          5.0,
        ),
        height: 40.0,
        width: mediaQuery.size.width / 3.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(0xFFE9E9E9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
        _getSocialButtonWidget("WhatsApp", mediaQuery, context, _openWhatsApp),
        _getSocialButtonWidget("Эл. почта", mediaQuery, context, _openEmailApp),
        _getSocialButtonWidget(
            "Telegram", mediaQuery, context, _openTelegramApp),
      ],
    );
  }
}
