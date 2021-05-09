import 'package:flutter/material.dart';

import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/product_controller.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/screens/products_by_category/products_by_category_screen_components.dart';

class ProductsByCategoryScreen extends StatefulWidget {
  final String category;

  const ProductsByCategoryScreen({this.category});

  @override
  _ProductsByCategoryScreenState createState() =>
      _ProductsByCategoryScreenState();
}

class _ProductsByCategoryScreenState extends State<ProductsByCategoryScreen> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<dynamic> currProducts;

  int currDataGroupNum = 1;
  ScrollController scrollController;
  bool isLoadingNewData = false;

  bool isOriginalDataRetrieved = false;

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController()..addListener(_scrollListener);
    _fetchOriginalData().then((value) {
      setState(() {
        isOriginalDataRetrieved = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _startLoadingNewData();
    }
  }

  void _startLoadingNewData() {
    setState(() {
      isLoadingNewData = true;
      currDataGroupNum++;
      _fetchNewData();
    });
  }

  _fetchNewData() async {
    return ProductController.getProductsForCategory(
      limit: 4,
      category: widget.category,
      groupNum: currDataGroupNum,
    ).then(
      (newProducts) {
        setState(
          () {
            if (newProducts == null) {
              currDataGroupNum--;
            } else {
              currProducts.addAll(newProducts);
            }

            isLoadingNewData = false;
          },
        );
      },
    );
  }

  Future _fetchOriginalData() async {
    ProductController.getProductsForCategory(
            category: widget.category, limit: 4 * currDataGroupNum)
        .then((newProducts) {
      setState(() {
        currProducts = newProducts;
        isOriginalDataRetrieved = true;
      });
    });
  }

  Widget _getUpperButtonsRow(MediaQueryData mediaQuery) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 10.0,
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back_rounded,
                color: ProjectConstants.APP_FONT_COLOR,
                size: 35.0,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              right: 10.0,
            ),
            child: Row(
              children: [
                Text(
                  "Фильтры",
                  style: TextStyle(
                    fontSize: 14 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontWeight: FontWeight.w600,
                    color: ProjectConstants.APP_FONT_COLOR,
                  ),
                ),
                Icon(
                  Icons.format_list_bulleted_sharp,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProductsListView(MediaQueryData mediaQuery) {
    var productsToShow = currProducts;

    return Container(
      height: mediaQuery.size.height,
      width: mediaQuery.size.width,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        itemCount: (productsToShow.length / 2).round(),
        itemBuilder: (_, index) => ProductByCategoryScreenComponent(
          category: widget.category,
          leftPrJson: productsToShow[2 * index],
          rightPrJson: (2 * index + 1 < productsToShow.length)
              ? productsToShow[2 * index + 1]
              : null,
        ),
      ),
    );
  }

  Widget _getFetchingLoaderWidget(MediaQueryData mediaQuery) {
    return isLoadingNewData
        ? Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              width: 70.0,
              height: 70.0,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          )
        : SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }

  Widget _getBodyWidget(BuildContext context) {
    if (!isOriginalDataRetrieved || currProducts == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          _getUpperButtonsRow(mediaQuery),
          Stack(
            children: [
              _getProductsListView(mediaQuery),
              _getFetchingLoaderWidget(mediaQuery),
            ],
          ),
        ],
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
        bottomNavigationBar: getBottomNavigationBar(context),
      ),
    );
  }
}
