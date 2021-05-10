import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/category_controller.dart';
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
          width: mediaQuery.size.width * 0.90,
          height: mediaQuery.size.height * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            image: DecorationImage(
              image: AssetImage("assets/images/${categoryInfo["code"]}.jpg"),
              fit: BoxFit.fill,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: categoriesList
              .map(
                (e) => Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: _getCategoryWidget(context, e),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
        body: _getBodyWidget(context),
        appBar: getAppBar(context),
        bottomNavigationBar: getBottomNavigationBar(
          context,
          isMenu: true,
        ),
      ),
    );
  }
}
