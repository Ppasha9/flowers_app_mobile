import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/models/favorites_model.dart';
import 'package:orlove_app/screens/product/product_screen.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';
import 'package:provider/provider.dart';

class ProductsListElementWidget extends StatefulWidget {
  final dynamic data;

  const ProductsListElementWidget({this.data});

  @override
  _ProductsListElementWidgetState createState() =>
      _ProductsListElementWidgetState();
}

class _ProductsListElementWidgetState extends State<ProductsListElementWidget> {
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
        height: mediaQuery.size.height / 3,
        width: mediaQuery.size.width / 2.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Container(
                  height: mediaQuery.size.height / 4,
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
            SizedBox(
              height: 8.0,
            ),
            Column(
              children: [
                Text(
                  "${Utils.fromUTF8(widget.data["name"])}",
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
          ],
        ),
      ),
    );
  }
}
