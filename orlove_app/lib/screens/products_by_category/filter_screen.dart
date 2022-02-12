import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/category_controller.dart';
import 'package:orlove_app/http/common_controller.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/utils/utils.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterProductsScreen extends StatefulWidget {
  final bool isSortPriceUp;
  final bool isSortPriceDown;
  final SfRangeValues priceRangeValues;
  final double maxPrice;
  final List<String> selectedTags;
  final List<String> selectedFlowers;
  final bool hasCategoryChoice;
  final String selectedCategory;

  const FilterProductsScreen({
    this.isSortPriceUp,
    this.isSortPriceDown,
    this.priceRangeValues,
    this.maxPrice,
    this.selectedTags,
    this.selectedFlowers,
    this.hasCategoryChoice,
    this.selectedCategory,
  });

  @override
  _FilterProductsScreenState createState() => _FilterProductsScreenState();
}

class _FilterProductsScreenState extends State<FilterProductsScreen> {
  bool _isSortPriceUp = true;
  bool _isSortPriceDown = false;

  bool _hasCategoryChoice = false;
  String _selectedCategory;

  SfRangeValues _currPriceRange;

  List<String> _allTags;
  List<String> _allFlowers;
  List<String> _allCategories;

  List<String> _selectedTags = [];
  List<String> _selectedFlowers = [];

  @override
  initState() {
    _isSortPriceDown = widget.isSortPriceDown;
    _isSortPriceUp = widget.isSortPriceUp;
    _currPriceRange = widget.priceRangeValues;
    _selectedTags = widget.selectedTags;
    _selectedFlowers = widget.selectedFlowers;
    _hasCategoryChoice = widget.hasCategoryChoice;
    _selectedCategory = widget.selectedCategory;

    CommonController.getAllTagsList().then((value) {
      setState(() {
        _allTags = [];
        (value as List<dynamic>).forEach((element) {
          _allTags.add(Utils.fromUTF8(element.toString()));
        });
      });
    });

    CommonController.getAllFlowersList().then((value) {
      setState(() {
        _allFlowers = [];
        (value as List<dynamic>).forEach((element) {
          _allFlowers.add(Utils.fromUTF8(element.toString()));
        });
      });
    });

    if (_hasCategoryChoice) {
      CategoryController.getAllCategories().then((value) {
        setState(() {
          _allCategories = [];
          (value as List<dynamic>).forEach((element) {
            _allCategories.add(Utils.fromUTF8(element.toString()));
          });
        });
      });
    }

    super.initState();
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
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            margin: const EdgeInsets.only(
              right: 10.0,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFFFB8C1),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                const BoxShadow(
                  color: Colors.grey,
                ),
                const BoxShadow(
                  color: Color(0xFFFFB8C1),
                  spreadRadius: -12.0,
                  blurRadius: 12.0,
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  "Фильтры",
                  style: TextStyle(
                    fontSize: 14 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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

  Widget _getPriceUpWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        setState(
          () {
            _isSortPriceUp = !_isSortPriceUp;
            if (_isSortPriceUp && _isSortPriceDown) {
              _isSortPriceDown = !_isSortPriceDown;
            }
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 30.0,
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isSortPriceUp
                      ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                      : ProjectConstants.APP_FONT_COLOR,
                  width: 2.0,
                ),
                color: _isSortPriceUp
                    ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                    : ProjectConstants.BACKGROUND_SCREEN_COLOR,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              "По возрастанию цены",
              style: TextStyle(
                fontSize: 15 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPriceDownWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        setState(
          () {
            _isSortPriceDown = !_isSortPriceDown;
            if (_isSortPriceDown && _isSortPriceUp) {
              _isSortPriceUp = !_isSortPriceUp;
            }
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 30.0,
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isSortPriceDown
                      ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                      : ProjectConstants.APP_FONT_COLOR,
                  width: 2.0,
                ),
                color: _isSortPriceDown
                    ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                    : ProjectConstants.BACKGROUND_SCREEN_COLOR,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              "По убыванию цены",
              style: TextStyle(
                fontSize: 15 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFlowersSelectWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    List<Widget> children = [];

    _allFlowers.forEach((e) {
      children.add(
        GestureDetector(
          onTap: () {
            if (_selectedFlowers.contains(e)) {
              _selectedFlowers.remove(e);
            } else {
              _selectedFlowers.add(e);
            }
            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 2.0,
            ),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                color: ProjectConstants.DEFAULT_STROKE_COLOR,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
              color: _selectedFlowers.contains(e)
                  ? Color(0xFFFFB8C1)
                  : Colors.white,
            ),
            child: Text(
              e,
              style: TextStyle(
                fontSize: 12 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: _selectedFlowers.contains(e)
                    ? Colors.white
                    : ProjectConstants.APP_FONT_COLOR,
              ),
            ),
          ),
        ),
      );
    });

    return Container(
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Wrap(
        children: children,
      ),
    );
  }

  Widget _getPriceWidget(BuildContext context) {
    double maxPriceDelimeter = 1000;
    if (widget.maxPrice <= 2500) {
      maxPriceDelimeter = 250;
    } else if (widget.maxPrice <= 5000) {
      maxPriceDelimeter = 500;
    }

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 13,
          child: RangeSlider(
            values: RangeValues(
              _currPriceRange.start.round().toDouble(),
              _currPriceRange.end.round().toDouble(),
            ),
            min: 0.0,
            max: widget.maxPrice,
            activeColor: Color(0xFFD2D1D1),
            inactiveColor: ProjectConstants.BUTTON_TEXT_COLOR,
            divisions: (widget.maxPrice / maxPriceDelimeter).round(),
            labels: RangeLabels(
              _currPriceRange.start.round().toString(),
              _currPriceRange.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                if (values.end - values.start >= maxPriceDelimeter) {
                  _currPriceRange = SfRangeValues(
                    values.start,
                    values.end,
                  );
                } else {
                  if (_currPriceRange.start == values.start) {
                    _currPriceRange = SfRangeValues(
                      values.start,
                      values.start + maxPriceDelimeter,
                    );
                  } else {
                    _currPriceRange = SfRangeValues(
                      values.end - maxPriceDelimeter,
                      values.end,
                    );
                  }
                }
              });
            },
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                color: Color(0xFFF3F3F3),
              ),
              margin: EdgeInsets.only(left: 10.0),
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'От: ${_currPriceRange.start.round()} Руб.',
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
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                color: Color(0xFFF3F3F3),
              ),
              margin: EdgeInsets.only(right: 10.0),
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'До: ${_currPriceRange.end.round()} Руб.',
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
      ],
    );
  }

  Widget _getSubmitButton(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        dynamic data = {};
        data["sortPriceUp"] = _isSortPriceUp;
        data["sortPriceDown"] = _isSortPriceDown;
        data["priceRange"] = _currPriceRange;
        data["selectedTags"] = _selectedTags;
        data["selectedFlowers"] = _selectedFlowers;

        Navigator.pop(
          context,
          data,
        );
      },
      child: Center(
        child: Container(
          height: 50,
          width: mediaQuery.size.width / 1.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
            color: ProjectConstants.BUTTON_BACKGROUND_COLOR,
          ),
          child: Center(
            child: Text(
              "Подтвердить",
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

  Widget _getClearButton(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.pop(context, null);
      },
      child: Center(
        child: Container(
          height: 50,
          width: mediaQuery.size.width / 1.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
            color: Color(0xFFFFE3E7),
          ),
          child: Center(
            child: Text(
              "Очистить",
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

  Widget _getTagsSelectWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    List<Widget> children = [];

    _allTags.forEach((e) {
      children.add(
        GestureDetector(
          onTap: () {
            if (_selectedTags.contains(e)) {
              _selectedTags.remove(e);
            } else {
              _selectedTags.add(e);
            }
            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 2.0,
            ),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                color: ProjectConstants.DEFAULT_STROKE_COLOR,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
              color:
                  _selectedTags.contains(e) ? Color(0xFFFFB8C1) : Colors.white,
            ),
            child: Text(
              e,
              style: TextStyle(
                fontSize: 12 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: _selectedTags.contains(e)
                    ? Colors.white
                    : ProjectConstants.APP_FONT_COLOR,
              ),
            ),
          ),
        ),
      );
    });

    return Container(
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Wrap(
        children: children,
      ),
    );
  }

  Widget _getCategorySelectWidget(BuildContext context) {
    if (!_hasCategoryChoice) {
      return Container();
    }

    MediaQueryData mediaQuery = MediaQuery.of(context);

    List<Widget> children = [];
    _allCategories.forEach((e) {
      children.add(
        GestureDetector(
          onTap: () {
            if (_selectedCategory == e) {
              _selectedCategory = "";
            } else {
              _selectedCategory = e;
            }

            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 2.0,
            ),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                color: ProjectConstants.DEFAULT_STROKE_COLOR,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
              color: _selectedCategory == e ? Color(0xFFFFB8C1) : Colors.white,
            ),
            child: Text(
              e,
              style: TextStyle(
                fontSize: 12 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: _selectedCategory == e
                    ? Colors.white
                    : ProjectConstants.APP_FONT_COLOR,
              ),
            ),
          ),
        ),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 20.0,
          ),
          child: Text(
            "Категория",
            style: TextStyle(
              fontSize: 16 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              fontWeight: FontWeight.bold,
              color: ProjectConstants.APP_FONT_COLOR,
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Wrap(
          children: [],
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    if (_allTags == null ||
        _allTags.length == 0 ||
        _allFlowers == null ||
        _allFlowers.length == 0 ||
        (_hasCategoryChoice &&
            (_allCategories == null || _allCategories.length == 0))) {
      return Center(
        child: const CircularProgressIndicator(),
      );
    }

    MediaQueryData mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          _getUpperButtonsRow(mediaQuery),
          SizedBox(
            height: 15.0,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 20.0,
            ),
            child: Text(
              "Сортировка",
              style: TextStyle(
                fontSize: 16 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                fontWeight: FontWeight.bold,
                color: ProjectConstants.APP_FONT_COLOR,
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          _getPriceUpWidget(context),
          SizedBox(
            height: 15.0,
          ),
          _getPriceDownWidget(context),
          SizedBox(
            height: 25.0,
          ),
          _getCategorySelectWidget(context),
          Container(
            margin: const EdgeInsets.only(
              left: 20.0,
            ),
            child: Text(
              "Цветы",
              style: TextStyle(
                fontSize: 16 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                fontWeight: FontWeight.bold,
                color: ProjectConstants.APP_FONT_COLOR,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          _getFlowersSelectWidget(context),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 20.0,
            ),
            child: Text(
              "Тэги",
              style: TextStyle(
                fontSize: 16 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                fontWeight: FontWeight.bold,
                color: ProjectConstants.APP_FONT_COLOR,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          _getTagsSelectWidget(context),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 20.0,
            ),
            child: Text(
              "Цена (руб.)",
              style: TextStyle(
                fontSize: 16 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                fontWeight: FontWeight.bold,
                color: ProjectConstants.APP_FONT_COLOR,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          _getPriceWidget(context),
          SizedBox(
            height: 50.0,
          ),
          _getSubmitButton(context),
          SizedBox(
            height: 10.0,
          ),
          _getClearButton(context),
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
