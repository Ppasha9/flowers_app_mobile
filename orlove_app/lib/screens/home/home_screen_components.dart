import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:orlove_app/http/product_controller.dart';

import 'package:orlove_app/languages/language_constants.dart';
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
            fit: BoxFit.fill,
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
  bool isFavourite;

  Future _onHeartPressed(BuildContext context) async {
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

    if (isFavourite) {
      await ProductController.removeProductFromFavourite(widget.data["id"])
          .then((value) {
        setState(() {});
      });
    } else {
      await ProductController.addProductToFavourite(widget.data["id"])
          .then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    isFavourite = Utils.isProductFavouriteById(widget.data["id"]);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height / 4.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20.0,
            ),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => ProductScreen(
                          id: widget.data["id"],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: mediaQuery.size.width / 2.2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.data["picture"]["url"]),
                        fit: BoxFit.fill,
                      ),
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(8.0)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: mediaQuery.size.width / 2.2 - 40.0,
                    top: 10.0,
                  ),
                  child: GestureDetector(
                    //onTap: () => _onHeartPressed(context),
                    onTap: () {},
                    child: Icon(
                      isFavourite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: isFavourite ? Colors.red : Colors.white,
                      size: 35.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            margin: const EdgeInsets.only(
              right: 40.0,
            ),
            width: mediaQuery.size.width / 3,
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
                    fontWeight: FontWeight.w600,
                    color: ProjectConstants.APP_FONT_COLOR,
                  ),
                ),
                Text(
                  "${widget.data["price"]} Руб.",
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
      height: MediaQuery.of(context).size.height / 3.8,
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
