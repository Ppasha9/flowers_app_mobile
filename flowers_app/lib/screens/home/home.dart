import 'package:flowers_app/screens/products_by_category/products_by_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flowers_app/rest_api/rest_api_product.dart';
import 'package:flowers_app/components/navigation_bar.dart';
import 'package:flowers_app/screens/catalog/catalog.dart';
import 'components.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBFF),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
            future: ProductService.getOneProductPerEachCategory(),
            builder: (context, snapshot) {
              final productsToCategories = snapshot.data;

              if (snapshot.connectionState == ConnectionState.done) {
                final arr = productsToCategories["elems"];

                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              TopBarProductContainer(productJson: arr[index]),
                          itemCount: arr.length,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Lavanda',
                          style: TextStyle(
                            fontSize: 35,
                            color: Color(0xFF989797),
                            fontFamily: 'Book Antiqua',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 8.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Новинки',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFB1ADAD),
                      fontFamily: 'Book Antiqua',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 8.0),
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductsByCategoryScreen(
                            category: 'New',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Смотреть все >',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFB1ADAD),
                        fontFamily: 'Book Antiqua',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          FutureBuilder(
            future: ProductService.getProductsForCategory(category: 'New'),
            builder: (context, snapshot) {
              final newProducts = snapshot.data;

              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) => NewProductContainer(
                      productJson: newProducts["products"][index],
                    ),
                    itemCount: newProducts["products"].length,
                  ),
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 8.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Подборки',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFB1ADAD),
                      fontFamily: 'Book Antiqua',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 8.0),
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => CatalogScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Каталог >',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFB1ADAD),
                        fontFamily: 'Book Antiqua',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
          ),
          // Container(
          //   margin: EdgeInsets.only(left: 8.0),
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     'Вам может понравится',
          //     style: TextStyle(
          //       fontSize: 13,
          //       color: Color(0xFFB1ADAD),
          //       fontFamily: 'Book Antiqua',
          //     ),
          //   ),
          // ),
          // Container(
          //   height: MediaQuery.of(context).size.height / 3.5,
          // ),
          Container(
            margin: EdgeInsets.only(left: 8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Мы в соцсетях',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFB1ADAD),
                fontFamily: 'Book Antiqua',
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 15,
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    alignment: Alignment.centerRight,
                    child: Image.asset('assets/images/home_screen/vk_icon.png'),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                        'assets/images/home_screen/instagram_icon.png'),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width / 5,
          )
        ],
      ),
      bottomNavigationBar: getNavigationBar(context),
    );
  }
}
