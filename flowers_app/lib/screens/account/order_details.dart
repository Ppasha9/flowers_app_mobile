import 'package:flowers_app/common/utils.dart';
import 'package:flowers_app/components/navigation_bar.dart';
import 'package:flowers_app/rest_api/rest_api_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  final num id;

  OrderDetailsScreen({Key key, this.id}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState(id: id);
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final num id;

  bool _isLoaded = false;
  dynamic _orderInfo;

  _OrderDetailsScreenState({this.id});

  Future<dynamic> _fetchOrderInfo() async {
    return await OrderService.getOrderDetails(id);
  }

  @override
  void initState() {
    super.initState();

    _fetchOrderInfo().then((value) {
      setState(() {
        _orderInfo = value;
        _isLoaded = true;
      });
    });
  }

  Color _getStatusColor(String status) {
    if (status == "Forming") {
      return Colors.blueAccent;
    } else if (status == "Succeeded") {
      return Colors.greenAccent;
    } else if (status == "Shipping") {
      return Colors.yellowAccent;
    }

    return Colors.redAccent;
  }

  String _getStatusText(String status) {
    if (status == "Forming") {
      return "Формируется";
    } else if (status == "Shipping") {
      return "В пути";
    } else if (status == "Succeeded") {
      return "Доставлен";
    }

    return "Отменен";
  }

  Widget _getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      primary: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF754831),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 6,
        ),
        width: MediaQuery.of(context).size.width / 3,
        alignment: Alignment.center,
        child: Center(
          child: Text(
            'Заказ #${_orderInfo["id"]}',
            style: TextStyle(
              fontSize: 25,
              color: Color(0xFFB1ADAD),
              fontFamily: 'Book Antiqua',
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        child: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          width: 120,
          height: 20,
          decoration: BoxDecoration(
            color: _getStatusColor(_orderInfo["status"]),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Center(
            child: Text(
              _getStatusText(_orderInfo["status"]),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Book Antiqua Bold',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(4.0),
      ),
    );
  }

  Widget _getProductWidget(dynamic prInfo, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            color: Colors.grey,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 3,
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(prInfo["info"]["pictures"][0]["url"]),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 5.0),
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "${prInfo["info"]["price"]} Руб.",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Poor Richard',
                    color: Color(0xFF403D3D),
                  ),
                ),
                Text(
                  Utils.fromUTF8(prInfo["info"]["name"]),
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Poor Richard',
                    color: Color(0xFF403D3D),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 10.5),
                  child: Text(
                    'Количество: ${prInfo["amount"]}\nОбщая стоимость: ${prInfo["info"]["price"] * prInfo["amount"]}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Book Antiqua',
                      color: Color(0xFF403D3D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProductsListWidget(BuildContext context) {
    List<Widget> children = List<Widget>();

    children.add(
      Text(
        'Состав заказа',
        style: TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 18,
          fontFamily: 'Book Antiqua Bold',
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    for (dynamic pr in _orderInfo["products"]) {
      children.add(_getProductWidget(pr, context));
    }

    children.add(
      SizedBox(
        height: 5.0,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.blueGrey,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _getReceiverInfoWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.blueGrey,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Получатель',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 18,
              fontFamily: 'Book Antiqua Bold',
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0, left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Имя: ${Utils.fromUTF8(_orderInfo["receiverName"])}",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
                Text(
                  "Телефон: ${_orderInfo["receiverPhone"]}",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
                Text(
                  "Почта: ${_orderInfo["receiverEmail"]}",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDeliveryMethodString() {
    if (_orderInfo["deliveryMethod"] == "COURIER") {
      return "Курьером";
    }

    return "Самовывоз";
  }

  String _getDeliveryAddressString() {
    if (_orderInfo["deliveryMethod"] == "COURIER") {
      return "ул. ${_orderInfo["receiverStreet"]}, д. ${_orderInfo["receiverHouseNum"]}, кв./офис ${_orderInfo["receiverApartmentNum"]}";
    }

    return "Варшавская улица, д. 59";
  }

  String _getDeliveryComment() {
    return _orderInfo["deliveryComment"] != ""
        ? _orderInfo["deliveryComment"]
        : "Без комментария";
  }

  Widget _getShippingInfoWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.blueGrey,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Способ доставки',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 18,
              fontFamily: 'Book Antiqua Bold',
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0, left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Как: ${_getDeliveryMethodString()}",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
                Text(
                  "Куда/откуда: ${_getDeliveryAddressString()}",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
                Text(
                  "Комментарий: ${_getDeliveryComment()}",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getOrderWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _getProductsListWidget(context),
          _getReceiverInfoWidget(context),
          _getShippingInfoWidget(context),
        ],
      ),
    );
  }

  double _getShippingPrice() {
    if (_orderInfo["deliveryMethod"] == "COURIER") {
      return 300.0;
    }

    return 0.0;
  }

  double _getFinalPrice() {
    double cartPrice = _orderInfo["price"];

    if (_orderInfo["deliveryMethod"] == "COURIER") {
      return cartPrice + 300.0;
    }

    return cartPrice;
  }

  Widget _getFinalPriceWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Общая стоимость:",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontFamily: 'Book Antiqua Bold',
                ),
              ),
              Text(
                "${_orderInfo["price"]} Руб.",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontFamily: 'Poor Richard',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Доставка:",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontFamily: 'Book Antiqua Bold',
                ),
              ),
              Text(
                "${_getShippingPrice()} Руб.",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontFamily: 'Poor Richard',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Итого к оплате:",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontFamily: 'Book Antiqua Bold',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${_getFinalPrice()} Руб.",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontFamily: 'Poor Richard',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getOrderWidget(context),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                'Финальная стоимость',
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 18,
                  fontFamily: 'Book Antiqua Bold',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _getFinalPriceWidget(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _orderInfo == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFFFBFF),
      appBar: _getAppBar(context),
      bottomNavigationBar: getNavigationBar(context),
      body: _getBodyWidget(context),
    );
  }
}
