import 'package:flowers_app/common/utils.dart';
import 'package:flowers_app/languages/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flowers_app/screens/product/product.dart';

class ProductByCategoryScreenConstants {
  static const num ONE_FETCH_LIMIT = 4;
}

class ProductByCategoryScreenComponent extends StatelessWidget {
  final String category;
  final dynamic leftPrJson;
  final dynamic rightPrJson;

  ProductByCategoryScreenComponent(
      {Key key, this.category, this.leftPrJson, this.rightPrJson: null})
      : super(key: key);

  Widget _getPrContainer(BuildContext context, dynamic prJson) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              id: prJson["id"],
            ),
          ),
        );
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(12.0),
              height: MediaQuery.of(context).size.height / 3.5,
              width: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(prJson["picture"]["url"]),
                ),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            Text(
              LanguageConstants.fromEngToRus(category),
              style: TextStyle(
                fontFamily: 'Segoe Script',
                color: Color(0xFFB1ADAD),
                fontSize: 10.0,
              ),
            ),
            Text(
              Utils.fromUTF8(prJson["name"]),
              style: TextStyle(
                fontFamily: 'Poor Richard',
                color: Color(0xFF403D3D),
                fontSize: 10.0,
              ),
            ),
            Text(
              '${prJson["price"]} Руб.',
              style: TextStyle(
                fontSize: 10.0,
                fontFamily: 'Poor Richard',
                color: Color(0xFF403D3D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getRowContainer(BuildContext context) {
    final children = List<Widget>();

    children.add(
      Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width / 2,
        child: Container(
          alignment: Alignment.centerRight,
          child: _getPrContainer(context, leftPrJson),
        ),
      ),
    );

    if (rightPrJson != null) {
      children.add(
        Container(
          alignment: Alignment.centerRight,
          width: MediaQuery.of(context).size.width / 2,
          child: Container(
            alignment: Alignment.centerLeft,
            child: _getPrContainer(context, rightPrJson),
          ),
        ),
      );
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.5,
      child: _getRowContainer(context),
    );
  }
}
