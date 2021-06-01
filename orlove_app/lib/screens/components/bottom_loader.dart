import 'package:flutter/material.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:orlove_app/constants.dart';

BottomLoader getBottomLoader(BuildContext context) {
  BottomLoader bottomLoader = BottomLoader(
    context,
    loader: CircularProgressIndicator(),
    isDismissible: false,
  );
  bottomLoader.style(
    message: "Обрабатывается запрос",
    backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
    messageTextStyle: TextStyle(
      fontSize: 14 * MediaQuery.of(context).textScaleFactor,
      fontFamily: ProjectConstants.APP_FONT_FAMILY,
      fontWeight: FontWeight.w600,
      color: ProjectConstants.APP_FONT_COLOR,
    ),
  );
  return bottomLoader;
}
