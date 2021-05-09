import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/product_controller.dart';
import 'package:orlove_app/screens/product/product_screen.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';

class ProductsListElementWidget extends StatefulWidget {
  final dynamic data;

  const ProductsListElementWidget({this.data});

  @override
  _ProductsListElementWidgetState createState() =>
      _ProductsListElementWidgetState();
}

class _ProductsListElementWidgetState extends State<ProductsListElementWidget> {
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

    return GestureDetector(
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
        height: mediaQuery.size.height / 3.5,
        width: mediaQuery.size.width / 2.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: mediaQuery.size.height / 4.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.data["picture"]["url"]),
                      fit: BoxFit.fill,
                    ),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0)),
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
            Text(
              "${Utils.fromUTF8(widget.data["name"])}\n${widget.data["price"]} Руб.",
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
    );
  }
}
