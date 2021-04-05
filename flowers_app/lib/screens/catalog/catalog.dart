import 'package:flowers_app/rest_api/rest_api_category.dart';
import 'package:flowers_app/screens/products_by_category/products_by_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flowers_app/components/navigation_bar.dart';

class CatalogScreen extends StatelessWidget {
  Widget _getCategoryWidget(BuildContext context, dynamic categoryInfo) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        image: DecorationImage(
          image: AssetImage(
              "assets/images/catalog_screen/${categoryInfo["code"]}.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => new ProductsByCategoryScreen(
                category: categoryInfo["code"],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Container(
        width: MediaQuery.of(context).size.width / 3.3,
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF754831),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      primary: false,
      title: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 6,
        ),
        width: MediaQuery.of(context).size.width / 3.3,
        alignment: Alignment.center,
        child: Text(
          'Каталог',
          style: TextStyle(
            fontSize: 25,
            color: Color(0xFFB1ADAD),
            fontFamily: 'Book Antiqua',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBFF),
      appBar: _getAppBar(context),
      bottomNavigationBar: getNavigationBar(
        context,
        curScreen: NavigationScreens.CATALOG_SCREEN,
      ),
      body: FutureBuilder(
        future: CategoryService.getAllCategories(),
        builder: (context, snapshot) {
          final categories = snapshot.data;

          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              width: MediaQuery.of(context).size.width / 1.1,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (_, index) => _getCategoryWidget(
                  context,
                  categories[index],
                ),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
