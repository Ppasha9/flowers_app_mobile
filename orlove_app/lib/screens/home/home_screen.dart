import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/compilation_controller.dart';
import 'package:orlove_app/http/product_controller.dart';
import 'package:orlove_app/screens/compilation/all_compilations_screen.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/screens/components/social_icons.dart';
import 'package:orlove_app/screens/home/home_screen_components.dart';
import 'package:orlove_app/screens/products_by_category/products_by_category_screen.dart';

import '../../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAllLoaded = false;

  List<dynamic> productsPerCategory;
  dynamic dayProduct;
  List<dynamic> newProducts;
  List<CompilationCuttedFormDTO> compilations;

  Future<dynamic> _loadProductsPerCategory() async {
    return await ProductController.getProductPerCategory();
  }

  Future<dynamic> _loadDayProduct() async {
    return null;
  }

  Future<dynamic> _loadNewProducts() async {
    return await ProductController.getProductsForCategory(category: "New");
  }

  Future<List<CompilationCuttedFormDTO>> _loadCompilations() async {
    return await CompilationController.getAllCompilationsCuttedForms();
  }

  @override
  void initState() {
    _loadProductsPerCategory().then(
      (_productsPerCategory) {
        productsPerCategory = _productsPerCategory;
        _loadNewProducts().then(
          (_newProducts) {
            newProducts = _newProducts;
            _loadCompilations().then((_newCompilations) {
              compilations = _newCompilations;
              setState(
                () {
                  isAllLoaded = true;
                },
              );
            });
          },
        );
      },
    );
    super.initState();
  }

  Widget _getBodyWidget(BuildContext context) {
    if (!isAllLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            ProductPerEachCategoryCarouselWidget(
              products: productsPerCategory,
            ),
            SizedBox(
              height: 25.0,
            ),
            DayProductWidget(
              data: newProducts[0],
            ),
            SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20.0,
                  ),
                  child: Text(
                    "НОВИНКИ",
                    style: TextStyle(
                      fontSize: 14 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      fontWeight: FontWeight.w600,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 20.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => ProductsByCategoryScreen(
                            category: "New",
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "Смотреть все",
                          style: TextStyle(
                            fontSize: 14 * mediaQuery.textScaleFactor,
                            fontFamily: ProjectConstants.APP_FONT_FAMILY,
                            fontWeight: FontWeight.w600,
                            color: ProjectConstants.APP_FONT_COLOR,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: ProjectConstants.APP_FONT_COLOR,
                          size: 16.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            NewProductsListWidget(
              newProducts: newProducts,
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20.0,
                  ),
                  child: Text(
                    "ПОДБОРКИ",
                    style: TextStyle(
                      fontSize: 14 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      fontWeight: FontWeight.w600,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 20.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => AllCompilationsScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "Смотреть все",
                          style: TextStyle(
                            fontSize: 14 * mediaQuery.textScaleFactor,
                            fontFamily: ProjectConstants.APP_FONT_FAMILY,
                            fontWeight: FontWeight.w600,
                            color: ProjectConstants.APP_FONT_COLOR,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: ProjectConstants.APP_FONT_COLOR,
                          size: 16.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            CompilationsListWidget(
              compilations: compilations,
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20.0,
                  ),
                  child: Text(
                    "НАШИ СОЦИАЛЬНЫЕ СЕТИ",
                    style: TextStyle(
                      fontSize: 14 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      fontWeight: FontWeight.w600,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            SocialIconsWidget(),
            SizedBox(
              height: 20.0,
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
      appBar: getAppBar(context),
      bottomNavigationBar: getBottomNavigationBar(
        context,
        isHome: true,
      ),
    );
  }
}
