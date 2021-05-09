import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/http/product_controller.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';

class ProductPictureWidget extends StatelessWidget {
  final dynamic picData;

  const ProductPictureWidget({this.picData});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height / 2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(picData["url"]),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class ProductPicturesCarouselWidget extends StatefulWidget {
  final List<dynamic> productPics;
  final dynamic productInfo;

  const ProductPicturesCarouselWidget({this.productPics, this.productInfo});

  @override
  ProductPicturesCarouselWidgetState createState() =>
      ProductPicturesCarouselWidgetState();
}

class ProductPicturesCarouselWidgetState
    extends State<ProductPicturesCarouselWidget> {
  bool isFavourite;
  int currIndex = 0;

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
      await ProductController.removeProductFromFavourite(
              widget.productInfo["id"])
          .then((value) {
        setState(() {});
      });
    } else {
      await ProductController.addProductToFavourite(widget.productInfo["id"])
          .then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    isFavourite = Utils.isProductFavouriteById(widget.productInfo["id"]);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      child: Stack(
        children: [
          Container(
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
                  items: widget.productPics.map(
                    (elem) {
                      return Builder(
                        builder: (BuildContext ctx) {
                          return ProductPictureWidget(
                            picData: elem,
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.productPics.map(
                    (elem) {
                      int index = widget.productPics.indexOf(elem);
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
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 10.0,
              left: 10.0,
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 40.0,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: mediaQuery.size.width - 50.0,
              top: 10.0,
            ),
            child: GestureDetector(
              //onTap: () => _onHeartPressed(context),
              onTap: () {},
              child: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border_outlined,
                color: isFavourite ? Colors.red : Colors.white,
                size: 35.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
