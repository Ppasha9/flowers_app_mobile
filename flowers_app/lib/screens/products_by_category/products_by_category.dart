import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flowers_app/rest_api/rest_api_product.dart';
import 'package:flowers_app/screens/products_by_category/components.dart';
import 'package:flowers_app/components/navigation_bar.dart';
import 'package:flowers_app/languages/constants.dart';

class ProductsByCategoryScreen extends StatefulWidget {
  final String category;

  ProductsByCategoryScreen({Key key, this.category}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ProductsByCategoryScreenState(category: category);
}

class _ProductsByCategoryScreenState extends State<ProductsByCategoryScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final String category;

  dynamic _currProducts = <dynamic>[];
  dynamic _currFilteredProducts = <dynamic>[];

  int _currDataGroupNum = 1;
  ScrollController _scrollController;
  bool _isLoadingNewData = false;

  double _currMaxPrice;
  RangeValues _currRangeValues;

  bool _isFiltering = false;

  _ProductsByCategoryScreenState({this.category});

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _startLoaderNewData();
    }
  }

  void _startLoaderNewData() {
    setState(() {
      _isLoadingNewData = !_isLoadingNewData;
      _currDataGroupNum++;
      _fetchNewData();
    });
  }

  _fetchNewData() async {
    return ProductService.getProductsForCategory(
            category: category,
            limit: ProductByCategoryScreenConstants.ONE_FETCH_LIMIT,
            groupNum: _currDataGroupNum)
        .then((newProducts) {
      setState(() {
        if (newProducts == null) {
          _currDataGroupNum--;
        } else {
          _currProducts.addAll(newProducts["products"]);
        }

        _isLoadingNewData = !_isLoadingNewData;
      });
    });
  }

  Widget _getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Color(0xFF754831),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      primary: false,
      title: Center(
        child: Text(
          LanguageConstants.fromEngToRus(category),
          style: TextStyle(
            fontSize: 25,
            color: Color(0xFFB1ADAD),
            fontFamily: 'Book Antiqua',
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.filter_list_alt,
            color: Color(0xFF754831),
          ),
          onPressed: () {
            _showModalFilterSheet(context);
          },
        ),
      ],
    );
  }

  Future<Null> _fetchOriginalData() {
    return ProductService.getProductsForCategory(
            category: category,
            limit: ProductByCategoryScreenConstants.ONE_FETCH_LIMIT *
                _currDataGroupNum)
        .then((newProducts) {
      setState(() {
        _currProducts = newProducts["products"];
      });
    });
  }

  Future<Null> _fetchFilteredData() {
    return ProductService.filterCategoryProductsByPrice(
            category: category,
            limit: ProductByCategoryScreenConstants.ONE_FETCH_LIMIT *
                _currDataGroupNum,
            minPrice: _currRangeValues.start.round(),
            maxPrice: _currRangeValues.end.round())
        .then((filtertedProducts) {
      setState(() {
        _currFilteredProducts = filtertedProducts["products"];
      });
    });
  }

  Future<Null> _fetchCurrentData() {
    if (_isFiltering) {
      return _fetchFilteredData();
    } else {
      return _fetchOriginalData();
    }
  }

  Future<Null> _fetchMaxPrice() {
    return ProductService.getProductsMaxPriceByCategory(category: category)
        .then((maxPrice) {
      setState(() {
        _currMaxPrice = maxPrice;
        if (_currRangeValues == null) {
          _currRangeValues = RangeValues(0, maxPrice);
        }
      });
    });
  }

  Future<Null> _handleRefresh() {
    return _fetchCurrentData().whenComplete(() => _fetchMaxPrice());
  }

  Widget _getProductsListView(BuildContext context) {
    var productsToShow = _isFiltering ? _currFilteredProducts : _currProducts;

    return Container(
      height: MediaQuery.of(context).size.height * 4,
      width: MediaQuery.of(context).size.width,
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          itemCount: (productsToShow.length / 2).round(),
          itemBuilder: (_, index) => ProductByCategoryScreenComponent(
            category: category,
            leftPrJson: productsToShow[2 * index],
            rightPrJson: (2 * index + 1 < productsToShow.length)
                ? productsToShow[2 * index + 1]
                : null,
          ),
        ),
      ),
    );
  }

  Widget _getFetchingLoaderWidget(BuildContext conext) {
    return _isLoadingNewData
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

  void startFiltering() {
    setState(() {
      if (_currRangeValues.start == 0 &&
          _currRangeValues.end == _currMaxPrice) {
        _isFiltering = false;
        return;
      }

      _isFiltering = true;
      _fetchFilteredData();
    });
  }

  void _showModalFilterSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              height: MediaQuery.of(context).size.height / 3.5,
              decoration: BoxDecoration(
                color: Color(0xFFFFFBFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width / 3.3,
                        margin: EdgeInsets.only(left: 10.0),
                        child: TextButton(
                          onPressed: () {
                            modalSetState(() {
                              _currRangeValues = RangeValues(0, _currMaxPrice);
                            });
                          },
                          child: Text(
                            'Очистить',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFB1ADAD),
                              fontFamily: 'Book Antiqua',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          'Фильтры',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFB1ADAD),
                            fontFamily: 'Book Antiqua Bold',
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.of(context).size.width / 3.3,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.close,
                            color: Color(0xFF754831),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    alignment: Alignment.center,
                    child: Divider(
                      color: Color(0xFFD9D9D9),
                      height: 5.0,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Цена',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFB1ADAD),
                        fontFamily: 'Book Antiqua',
                      ),
                    ),
                  ),
                  RangeSlider(
                    values: _currRangeValues,
                    min: 0,
                    max: _currMaxPrice,
                    activeColor: Color(0xFF754831),
                    inactiveColor: Color(0xFFACACAC),
                    onChanged: (RangeValues values) {
                      modalSetState(() {
                        if (values.end - values.start >= 800) {
                          _currRangeValues = values;
                        } else {
                          if (_currRangeValues.start == values.start) {
                            _currRangeValues =
                                RangeValues(values.start, values.start + 800);
                          } else {
                            _currRangeValues =
                                RangeValues(values.end - 800, values.end);
                          }
                        }
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFACACAC),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Color(0xFFF3F3F3),
                        ),
                        margin: EdgeInsets.only(left: 10.0),
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'От: ${_currRangeValues.start.round()} Руб.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF111111),
                              fontFamily: 'Book Antiqua',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFACACAC),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Color(0xFFF3F3F3),
                        ),
                        margin: EdgeInsets.only(right: 10.0),
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'До: ${_currRangeValues.end.round()} Руб.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF111111),
                              fontFamily: 'Book Antiqua',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  RaisedButton(
                    color: Color(0xFFC9C9C9),
                    onPressed: () {
                      Navigator.of(context).pop();
                      startFiltering();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Применить',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFFFFFFF),
                              fontFamily: 'Book Antiqua Bold',
                            ),
                          ),
                          Icon(
                            Icons.format_list_numbered,
                            color: Color(0xFFFFFFFF),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBFF),
      appBar: _getAppBar(context),
      bottomNavigationBar: getNavigationBar(context),
      body: Stack(
        children: <Widget>[
          _getProductsListView(context),
          _getFetchingLoaderWidget(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _refreshIndicatorKey.currentState.show();
        },
        child: Icon(
          Icons.refresh,
          color: Color(0xFF754831),
        ),
        backgroundColor: Color(0xFFFFFFFF),
      ),
    );
  }
}
