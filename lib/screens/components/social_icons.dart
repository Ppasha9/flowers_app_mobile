import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';

class SocialIconsWidget extends StatelessWidget {
  final VK_URL = "https://vk.com/ppasha9";
  final INSTAGRAM_URL = "";

  _openVK() async {}

  _openInstagram() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _openVK,
            child: Container(
              margin: const EdgeInsets.only(
                right: 15.0,
              ),
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/vk_icon.png",
                  ),
                ),
              ),
            ),
          ),
          VerticalDivider(
            color: ProjectConstants.APP_FONT_COLOR,
            width: 10.0,
          ),
          GestureDetector(
            onTap: _openInstagram,
            child: Container(
              margin: const EdgeInsets.only(
                left: 15.0,
              ),
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/instagram_icon.png",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
