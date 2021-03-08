import 'package:flowers_app/common/utils.dart';
import 'package:flowers_app/components/navigation_bar.dart';
import 'package:flowers_app/rest_api/rest_api_order.dart';
import 'package:flowers_app/screens/account/order_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoaded = false;
  dynamic _orders;

  Future<dynamic> _fetchOrdersInfo() async {
    return await OrderService.getOrders();
  }

  @override
  void initState() {
    super.initState();

    _fetchOrdersInfo().then((value) {
      setState(() {
        _orders = value;
        _isLoaded = true;
      });
    });
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
            'Мои заказы',
            style: TextStyle(
              fontSize: 25,
              color: Color(0xFFB1ADAD),
              fontFamily: 'Book Antiqua',
            ),
          ),
        ),
      ),
    );
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

  Widget _getProductWidget(dynamic prInfo, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.black26,
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Название: ',
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 14,
                  fontFamily: 'Book Antiqua Bold',
                ),
              ),
              Text(
                Utils.fromUTF8(prInfo["name"]),
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 14,
                  fontFamily: 'Book Antiqua Bold',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Цена: ',
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 14,
                  fontFamily: 'Book Antiqua Bold',
                ),
              ),
              Text(
                "${prInfo["price"]} Руб.",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 13,
                  fontFamily: 'Poor Richard',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Количество: ',
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 14,
                  fontFamily: 'Book Antiqua Bold',
                ),
              ),
              Text(
                "${prInfo["amount"]}",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 13,
                  fontFamily: 'Poor Richard',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Общая стоимость: ',
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 14,
                  fontFamily: 'Book Antiqua Bold',
                ),
              ),
              Text(
                "${prInfo["price"] * prInfo["amount"]} Руб.",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 13,
                  fontFamily: 'Poor Richard',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _getShippingPrice(dynamic orderInfo) {
    return orderInfo["deliveryMethod"] == "COURIER" ? 300.0 : 0.0;
  }

  void _openOrderDetails(dynamic orderInfo, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(
          id: orderInfo["id"],
        ),
      ),
    );
  }

  Widget _getOrderWidget(dynamic orderInfo, BuildContext context) {
    List<Widget> children = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Заказ #${orderInfo["id"]} на ${orderInfo["fullPrice"]} Руб.',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 13,
              fontFamily: 'Poor Richard',
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0),
            width: 120,
            height: 20,
            decoration: BoxDecoration(
              color: _getStatusColor(orderInfo["status"]),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Center(
              child: Text(
                _getStatusText(orderInfo["status"]),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Book Antiqua Bold',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      Divider(
        color: Colors.black54,
      ),
      Text(
        'Состав заказа:',
        style: TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 14,
          fontFamily: 'Book Antiqua Bold',
          fontWeight: FontWeight.bold,
        ),
      ),
    ];

    for (dynamic prInfo in orderInfo["products"]) {
      children.add(_getProductWidget(prInfo, context));
    }

    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Доставка',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 14,
              fontFamily: 'Book Antiqua Bold',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${_getShippingPrice(orderInfo)} Руб.",
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 13,
              fontFamily: 'Poor Richard',
            ),
          ),
        ],
      ),
    );

    children.add(
      Divider(
        color: Colors.black54,
      ),
    );

    children.add(
      Container(
        height: 20,
        width: MediaQuery.of(context).size.width / 1.9,
        child: RaisedButton(
          color: Color(0xFFC9C9C9),
          onPressed: () => _openOrderDetails(orderInfo, context),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.9,
            alignment: Alignment.center,
            child: Text(
              'Подробнее',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFFFFFFF),
                fontFamily: 'Book Antiqua Bold',
              ),
            ),
          ),
        ),
      ),
    );

    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }

  List<Widget> _getOrdersWidgetsList(BuildContext context) {
    List<Widget> res = [];

    for (dynamic orderInfo in _orders["orders"]) {
      res.add(_getOrderWidget(orderInfo, context));
    }

    return res;
  }

  Widget _getBodyWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: _getOrdersWidgetsList(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _orders == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFFFBFF),
      bottomNavigationBar: getNavigationBar(context),
      appBar: _getAppBar(context),
      body: _getBodyWidget(context),
    );
  }
}
