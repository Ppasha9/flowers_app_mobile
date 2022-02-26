import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:orlove_app/http/compilation_controller.dart';
import 'package:orlove_app/screens/compilation/compilation_screen.dart';
import 'package:provider/provider.dart';

import 'package:orlove_app/languages/language_constants.dart';
import 'package:orlove_app/models/favorites_model.dart';
import 'package:orlove_app/screens/components/product_element_widget.dart';
import 'package:orlove_app/screens/product/product_screen.dart';
import 'package:orlove_app/screens/products_by_category/products_by_category_screen.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';

import '../../constants.dart';

class ProductPerCategoryWidget extends StatelessWidget {
  final dynamic data;

  const ProductPerCategoryWidget({this.data});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => ProductsByCategoryScreen(
              category: data["category"],
            ),
          ),
        );
      },
      child: Container(
        height: mediaQuery.size.height / 2,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(data["product"]["picture"]["url"]),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(
            bottom: 10.0,
          ),
          child: Text(
            LanguageConstants.fromEngToRus(data["category"]),
            style: TextStyle(
              fontSize: 18 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ProductPerEachCategoryCarouselWidget extends StatefulWidget {
  final List<dynamic> products;

  const ProductPerEachCategoryCarouselWidget({this.products});

  @override
  _ProductPerEachCategoryCarouselWidgetState createState() =>
      _ProductPerEachCategoryCarouselWidgetState();
}

class _ProductPerEachCategoryCarouselWidgetState
    extends State<ProductPerEachCategoryCarouselWidget> {
  int currIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: mediaQuery.size.height / 2,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              pauseAutoPlayOnTouch: true,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  currIndex = index;
                });
              },
            ),
            items: widget.products.map(
              (elem) {
                return Builder(
                  builder: (BuildContext ctx) {
                    return ProductPerCategoryWidget(
                      data: elem,
                    );
                  },
                );
              },
            ).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.products.map(
              (elem) {
                int index = widget.products.indexOf(elem);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 3.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currIndex == index
                        ? Color.fromRGBO(0, 0, 0, 0.7)
                        : Color.fromRGBO(0, 0, 0, 0.2),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}

class DayProductWidget extends StatefulWidget {
  final dynamic data;

  const DayProductWidget({this.data});

  @override
  _DayProductWidgetState createState() => _DayProductWidgetState();
}

class _DayProductWidgetState extends State<DayProductWidget> {
  bool isFavorite = false;

  Future _onHeartPressed(
      BuildContext context, FavoritesModel favoritesModel) async {
    if (!SecureStorage.isLogged) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Внимание!"),
          content: Text(
              "Чтобы добавить товар в избранные, нужно войти в аккаунт/зарегистрироваться"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text("Окей"),
            ),
          ],
        ),
      );

      return;
    }

    if (isFavorite) {
      await favoritesModel.removeFavorite(widget.data["id"]);
    } else {
      await favoritesModel.addNewFavorite(widget.data["id"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    FavoritesModel favoritesModel = context.watch<FavoritesModel>();
    favoritesModel.isFavorite(widget.data["id"]).then((value) {
      setState(() {
        isFavorite = value;
      });
    });

    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height / 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => ProductScreen(
                      id: widget.data["id"],
                    ),
                  ),
                );
              },
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Container(
                    width: mediaQuery.size.width / 2.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.data["picture"]["url"]),
                        fit: BoxFit.fill,
                      ),
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(4.0)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onHeartPressed(context, favoritesModel),
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: 5.0,
                        top: 5.0,
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        color: isFavorite ? Color(0xFFFFB9C2) : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            margin: const EdgeInsets.only(
              right: 40.0,
            ),
            width: mediaQuery.size.width / 2.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Букет дня",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFB9C2),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  Utils.fromUTF8(widget.data["name"]),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontWeight: FontWeight.normal,
                    color: ProjectConstants.APP_FONT_COLOR,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "${Utils.getPriceCorrectString(widget.data["price"].round())} ₽",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontWeight: FontWeight.w600,
                    color: ProjectConstants.APP_FONT_COLOR,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewProductsListWidget extends StatelessWidget {
  final List<dynamic> newProducts;

  NewProductsListWidget({this.newProducts});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) => Container(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: ProductsListElementWidget(
              data: newProducts[index],
            ),
          ),
        ),
        itemCount: newProducts.length,
      ),
    );
  }
}

class CompilationListElementWidget extends StatelessWidget {
  final CompilationCuttedFormDTO compilationCuttedInfo;

  const CompilationListElementWidget({@required this.compilationCuttedInfo});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    print(compilationCuttedInfo.picUrl);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => CompilationScreen(
              id: compilationCuttedInfo.id,
            ),
          ),
        );
      },
      child: Container(
        height: mediaQuery.size.height / 4.5,
        width: mediaQuery.size.width / 2.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: mediaQuery.size.height / 5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(compilationCuttedInfo.picUrl),
                  fit: BoxFit.fill,
                ),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(4.0)),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "${compilationCuttedInfo.name}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                fontWeight: FontWeight.normal,
                color: ProjectConstants.APP_FONT_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompilationsListWidget extends StatelessWidget {
  final List<CompilationCuttedFormDTO> compilations;

  const CompilationsListWidget({@required this.compilations});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) => Container(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: CompilationListElementWidget(
              compilationCuttedInfo: compilations[index],
            ),
          ),
        ),
        itemCount: compilations.length,
      ),
    );
  }
}
