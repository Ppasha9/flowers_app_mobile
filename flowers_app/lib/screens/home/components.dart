import 'dart:convert';

import 'package:flowers_app/common/utils.dart';
import 'package:flowers_app/languages/constants.dart';
import 'package:flowers_app/screens/product/product.dart';
import 'package:flowers_app/screens/products_by_category/products_by_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopBarProductContainer extends StatelessWidget {
  final dynamic productJson;

  TopBarProductContainer({Key key, this.productJson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductsByCategoryScreen(
              category: productJson["category"],
            ),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 10.0),
          child: Text(
            LanguageConstants.fromEngToRus(productJson["category"]),
            style: TextStyle(
              fontFamily: 'Book Antiqua',
              fontSize: 35.0,
              color: Color(0xFF989797),
            ),
          ),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                new NetworkImage(productJson["product"]["pictures"][0]["url"]),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class NewProductContainer extends StatelessWidget {
  final dynamic productJson;

  NewProductContainer({Key key, this.productJson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              id: productJson["id"],
            ),
          ),
        );
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(5.0),
              height: MediaQuery.of(context).size.height / 5,
              width: MediaQuery.of(context).size.width / 3.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(productJson["picture"]["url"]),
                ),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            Text(
              'New',
              style: TextStyle(
                fontFamily: 'Segoe Script',
                color: Color(0xFFB1ADAD),
                fontSize: 10.0,
              ),
            ),
            Text(
              Utils.fromUTF8(productJson["name"]),
              style: TextStyle(
                fontFamily: 'Poor Richard',
                color: Color(0xFF403D3D),
                fontSize: 10.0,
              ),
            ),
            Text(
              '${productJson["price"]} Руб.',
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
}
