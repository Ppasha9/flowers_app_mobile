import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/product_controller.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/screens/products_by_category/products_by_category_screen_components.dart';

class ProductsByNameScreen extends StatefulWidget {
  final name;

  const ProductsByNameScreen({this.name});

  @override
  _ProductsByNameScreenState createState() => _ProductsByNameScreenState();
}

class _ProductsByNameScreenState extends State<ProductsByNameScreen> {
  List<dynamic> currProducts;
  bool isLoading = true;

  @override
  void initState() {
    _fetchData().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Future _fetchData() async {
    return ProductController.getProductsByName(widget.name).then((value) {
      setState(() {
        currProducts = value;
      });
    });
  }

  Widget _getUpperButtonsRow(MediaQueryData mediaQuery) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: Container(
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
    );
  }

  Widget _getProductsListView(MediaQueryData mediaQuery) {
    if (currProducts.length == 0) {
      return Center(
        child: Text(
          "Товаров с названием, похожим на '${widget.name}' не найдено.",
          style: TextStyle(
            color: ProjectConstants.APP_FONT_COLOR,
            fontFamily: ProjectConstants.APP_FONT_FAMILY,
            fontSize: 20 * mediaQuery.textScaleFactor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      height: mediaQuery.size.height,
      width: mediaQuery.size.width,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: (currProducts.length / 2).round(),
        itemBuilder: (_, index) => ProductByCategoryScreenComponent(
          leftPrJson: currProducts[2 * index],
          rightPrJson: (2 * index + 1 < currProducts.length)
              ? currProducts[2 * index + 1]
              : null,
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

    MediaQueryData mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getUpperButtonsRow(mediaQuery),
          _getProductsListView(mediaQuery),
          SizedBox(
            height: mediaQuery.size.height / 3,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      body: _getBodyWidget(context),
      appBar: getAppBar(context),
      bottomNavigationBar: getBottomNavigationBar(context),
    );
  }
}
