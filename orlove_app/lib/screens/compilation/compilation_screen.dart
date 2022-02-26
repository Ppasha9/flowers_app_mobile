import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/compilation_controller.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/screens/products_by_category/products_by_category_screen_components.dart';

class CompilationScreen extends StatefulWidget {
  final int id;

  const CompilationScreen({
    @required this.id,
  });

  @override
  _CompilationScreenState createState() => _CompilationScreenState();
}

class _CompilationScreenState extends State<CompilationScreen> {
  bool _isLoading = true;
  CompilationFullInfoFormDTO _info;

  Future<CompilationFullInfoFormDTO> _loadCompilationInfo() async {
    return CompilationController.getCompilationFullInfo(widget.id);
  }

  @override
  void initState() {
    _loadCompilationInfo().then((value) {
      setState(() {
        _isLoading = false;
        _info = value;
      });
    });
    super.initState();
  }

  dynamic _getProductDynamicDataFromDTO(ProductInCompilationCuttedFormDTO dto) {
    return {
      "id": dto.id,
      "name": dto.name,
      "price": dto.price,
      "picture": {
        "url": dto.picUrl,
      },
    };
  }

  Widget _getProductsGridWidget(MediaQueryData mediaQuery) {
    return Container(
      height: mediaQuery.size.height,
      width: mediaQuery.size.width,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: (_info.products.length / 2).round(),
        itemBuilder: (_, index) => ProductsRowInGridComponent(
          leftPrJson: _getProductDynamicDataFromDTO(_info.products[2 * index]),
          rightPrJson: (2 * index + 1 < _info.products.length)
              ? _getProductDynamicDataFromDTO(_info.products[2 * index + 1])
              : null,
        ),
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    MediaQueryData mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(
            "${_info.name}",
            style: TextStyle(
              fontSize: 16 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              fontWeight: FontWeight.w600,
              color: ProjectConstants.APP_FONT_COLOR,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          _getProductsGridWidget(mediaQuery),
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
