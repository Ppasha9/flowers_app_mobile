import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/category_controller.dart';
import 'package:orlove_app/languages/language_constants.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/screens/products_by_category/products_by_category_screen.dart';

class CatalogScreen extends StatefulWidget {
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  bool isLoading = true;
  List<dynamic> categoriesList;

  @override
  void initState() {
    super.initState();
    CategoryController.getAllCategories().then(
      (value) {
        categoriesList = value;
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  Widget _getCategoryWidget(BuildContext context, dynamic categoryInfo) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => ProductsByCategoryScreen(
            category: categoryInfo["code"],
          ),
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LanguageConstants.fromEngToRus(
                      categoryInfo["code"],
                    ),
                    style: TextStyle(
                      color: ProjectConstants.APP_FONT_COLOR,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      fontSize: 16 * mediaQuery.textScaleFactor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ProjectConstants.APP_FONT_COLOR,
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              const Divider(
                height: 3.0,
                thickness: 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getFilterButtonWidget(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {},
      child: Center(
        child: Container(
          height: 50,
          width: mediaQuery.size.width / 1.3,
          margin: const EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
            color: ProjectConstants.BUTTON_BACKGROUND_COLOR,
          ),
          child: Center(
            child: Text(
              "Фильтры",
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

  Widget _getBodyWidget(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: categoriesList
                  .map(
                    (e) => _getCategoryWidget(context, e),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      body: _getBodyWidget(context),
      appBar: getAppBar(context, hasFilters: true),
      bottomNavigationBar: getBottomNavigationBar(
        context,
        isMenu: true,
      ),
    );
  }
}
