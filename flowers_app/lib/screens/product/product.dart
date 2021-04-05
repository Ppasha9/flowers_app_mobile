import 'package:carousel_slider/carousel_slider.dart';
import 'package:flowers_app/common/utils.dart';
import 'package:flowers_app/languages/constants.dart';
import 'package:flowers_app/rest_api/rest_api_cart.dart';
import 'package:flowers_app/rest_api/rest_api_product.dart';
import 'package:flowers_app/screens/account/signin.dart';
import 'package:flowers_app/screens/cart/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flowers_app/components/navigation_bar.dart';

class ProductScreen extends StatefulWidget {
  final num id;

  ProductScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductScreenState(id: id);
}

class _ProductScreenState extends State<ProductScreen> {
  final num id;

  num _current = 0;
  dynamic prFullInfo;

  bool _isAddedToCart = false;
  bool _isLoggedIn = false;

  _ProductScreenState({this.id});

  Future<bool> _isProductInCartChecker() async {
    return await CartService.isProductInCart(id);
  }

  Future<void> _fetchProductFullInfo() async {
    ProductService.getProductFullInfo(id: id).then((value) {
      setState(() {
        prFullInfo = value;
      });
    });
  }

  @override
  initState() {
    super.initState();
    _fetchProductFullInfo().then((value) {
      _isProductInCartChecker().then((value) {
        setState(() {
          _isAddedToCart = value;
        });

        Utils.isUserLoggedIn().then((value) {
          setState(() {
            _isLoggedIn = value;
          });
        });
      });
    });
  }

  _addProductToCart(BuildContext context) async {
    await CartService.addProductToCart(id);
    setState(() {
      _isAddedToCart = true;
    });
  }

  Widget _getAddToCartButton(BuildContext context) {
    if (!_isLoggedIn) {
      return RaisedButton(
        color: Color(0xFFC9C9C9),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SigninScreen(),
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.4,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Войти/зарегистрироваться',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFFFFFFF),
                  fontFamily: 'Book Antiqua Bold',
                ),
              ),
              Icon(
                Icons.account_box_rounded,
                color: Color(0xFFFFFFFF),
              ),
            ],
          ),
        ),
      );
    }

    return RaisedButton(
      color: Color(0xFFC9C9C9),
      onPressed: _isAddedToCart
          ? () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => CartScreen(),
                ),
              )
          : () => _addProductToCart(context),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.7,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _isAddedToCart ? 'Уже в корзине' : 'Добавить в корзину',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFFFFFFFF),
                fontFamily: 'Book Antiqua Bold',
              ),
            ),
            Icon(
              Icons.add_shopping_cart_sharp,
              color: Color(0xFFFFFFFF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getProductBodyWidget(BuildContext context, dynamic fullInfo) {
    List<dynamic> pictures = fullInfo["pictures"];
    String allCategories = "";
    for (var category in fullInfo["categories"]) {
      allCategories += "${LanguageConstants.fromEngToRus(category)}, ";
    }
    allCategories = allCategories.substring(0, allCategories.length - 2);

    return ListView(
      children: <Widget>[
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  left: 20.0,
                ),
                alignment: Alignment.centerLeft,
                height: 30.0,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF754831),
                  ),
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height / 2,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    pauseAutoPlayOnTouch: true,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
                items: pictures.map((picture) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              picture["url"],
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: pictures.map((picture) {
                  int index = pictures.indexOf(picture);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 2.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      allCategories,
                      style: TextStyle(
                        fontFamily: 'Segoe Script',
                        color: Color(0xFFB1ADAD),
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      Utils.fromUTF8(fullInfo["name"]),
                      style: TextStyle(
                        fontFamily: 'Poor Richard',
                        color: Color(0xFF403D3D),
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      '${fullInfo["price"]} Руб.',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Poor Richard',
                        color: Color(0xFF403D3D),
                      ),
                    ),
                  ],
                ),
              ),
              _getAddToCartButton(context),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Детали',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFFB1ADAD),
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  Utils.fromUTF8(fullInfo["description"]),
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFB1ADAD),
                    fontFamily: 'Book Antiqua',
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Есть вопросы?',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFFB1ADAD),
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                          "assets/images/product_screen/whatsapp.png"),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Container(
                      alignment: Alignment.center,
                      child:
                          Image.asset("assets/images/product_screen/email.png"),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                          "assets/images/product_screen/telegram.png"),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Подробности',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFFB1ADAD),
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Вам может понравится',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFFB1ADAD),
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Вы недавно смотрели',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFFB1ADAD),
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBFF),
      bottomNavigationBar: getNavigationBar(context),
      body: (prFullInfo == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _getProductBodyWidget(context, prFullInfo),
    );
  }
}
