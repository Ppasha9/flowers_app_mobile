import 'package:bottom_loader/bottom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/cart_controller.dart';
import 'package:orlove_app/screens/components/bottom_loader.dart';
import 'package:orlove_app/screens/order_formation/order_formation_payment_screen.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';

class OrderFormationShippmentComponentsWidget extends StatefulWidget {
  @override
  _OrderFormationShippmentComponentsWidgetState createState() =>
      _OrderFormationShippmentComponentsWidgetState();
}

class _OrderFormationShippmentComponentsWidgetState
    extends State<OrderFormationShippmentComponentsWidget> {
  BottomLoader bottomLoader;

  final _formKey = GlobalKey<FormState>();

  final _streetTextController = TextEditingController();
  final _houseNumTextController = TextEditingController();
  final _roomTextController = TextEditingController();
  final _commentTextController = TextEditingController();

  bool _isCourierSelected = true;
  bool _isPickupSelected = false;

  DateTime selectedDate = null;

  Widget _getStreetInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _streetTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Улица*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.redAccent,
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
      validator: RequiredValidator(
        errorText: "Это поле обязательно к заполнению",
      ),
    );
  }

  Widget _getHouseNumInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _houseNumTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Номер дома*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.redAccent,
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
      validator: RequiredValidator(
        errorText: "Это поле обязательно к заполнению",
      ),
    );
  }

  Widget _getRoomNumInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _roomTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Квартира/офис*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.redAccent,
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
      validator: RequiredValidator(
        errorText: "Это поле обязательно к заполнению",
      ),
    );
  }

  Widget _getCommentInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      controller: _commentTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Комментарий*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.redAccent,
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
      validator: RequiredValidator(
        errorText: "Это поле обязательно к заполнению",
      ),
    );
  }

  Future _onConfirmButtonPressed(BuildContext context) async {
    if (!_isCourierSelected && !_isPickupSelected) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Внимание!"),
          content: Text("Нужно обязательно выбрать способ доставки!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Окей"),
            ),
          ],
        ),
      );
      return;
    }

    if (selectedDate == null) {
      Fluttertoast.showToast(msg: "Пожалуйста, выберите дату");
      return;
    }

    if (_isCourierSelected &&
        (_streetTextController.text.isEmpty ||
            _houseNumTextController.text.isEmpty ||
            _roomTextController.text.isEmpty)) {
      Fluttertoast.showToast(msg: "Пожалуйста, заполните данные о доставке");
      return;
    }

    if (!bottomLoader.isShowing()) {
      bottomLoader.display();
    }

    if (_isCourierSelected) {
      final validateRes = _formKey.currentState.validate();
      if (!validateRes) {
        if (bottomLoader.isShowing()) {
          bottomLoader.close();
        }

        return;
      }
    }

    await CartController.updateShippingInfo(
      _streetTextController.text,
      _houseNumTextController.text,
      _roomTextController.text,
      _commentTextController.text,
      _isCourierSelected ? "courier" : "pickup",
      selectedDate,
    );
    await CartController.increaseCartStatus();
    await Utils.getAllCartInfo();

    if (bottomLoader.isShowing()) {
      bottomLoader.close();
    }

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => OrderFormationPaymentScreen(),
      ),
    );
  }

  Widget _getCourierWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        setState(
          () {
            _isCourierSelected = !_isCourierSelected;
            if (_isCourierSelected && _isPickupSelected) {
              _isPickupSelected = !_isPickupSelected;
            }
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isCourierSelected
                          ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                          : ProjectConstants.APP_FONT_COLOR,
                      width: 2.0,
                    ),
                    color: _isCourierSelected
                        ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                        : ProjectConstants.BACKGROUND_SCREEN_COLOR,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "Курьер",
                  style: TextStyle(
                    fontSize: 15 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    color: ProjectConstants.APP_FONT_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              "+300 Руб.",
              style: TextStyle(
                fontSize: 15 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPickupWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        setState(
          () {
            _isPickupSelected = !_isPickupSelected;
            if (_isPickupSelected && _isCourierSelected) {
              _isCourierSelected = !_isCourierSelected;
            }
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isPickupSelected
                          ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                          : ProjectConstants.APP_FONT_COLOR,
                      width: 2.0,
                    ),
                    color: _isPickupSelected
                        ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                        : ProjectConstants.BACKGROUND_SCREEN_COLOR,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "Самовывоз",
                  style: TextStyle(
                    fontSize: 15 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    color: ProjectConstants.APP_FONT_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              "0 Руб.",
              style: TextStyle(
                fontSize: 15 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate != null ? selectedDate : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bottomLoader = getBottomLoader(context);

    if (SecureStorage.cartFullInfo["receiverStreet"] != "") {
      _streetTextController.text = SecureStorage.cartFullInfo["receiverStreet"];
      _houseNumTextController.text =
          SecureStorage.cartFullInfo["receiverHouseNum"];
      _roomTextController.text =
          SecureStorage.cartFullInfo["receiverApartmentNum"];
      _commentTextController.text =
          SecureStorage.cartFullInfo["deliveryComment"];
      _isCourierSelected =
          SecureStorage.cartFullInfo["deliveryMethod"] == "courier";
      _isPickupSelected = !_isCourierSelected;
    }

    print(selectedDate);

    final mediaQuery = MediaQuery.of(context);

    Widget dateTextWidget = selectedDate != null
        ? Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Text(
              "Вы выбрали дату: ${selectedDate.toString().split(' ')[0]}",
              style: TextStyle(
                fontSize: 16 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : Container();

    var children = <Widget>[
      SizedBox(
        height: 10.0,
      ),
      Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Text(
          "Выберите способ доставки",
          style: TextStyle(
            fontSize: 18 * mediaQuery.textScaleFactor,
            fontFamily: ProjectConstants.APP_FONT_FAMILY,
            color: ProjectConstants.APP_FONT_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      _getCourierWidget(context),
      SizedBox(
        height: 5.0,
      ),
      Divider(
        color: ProjectConstants.DEFAULT_STROKE_COLOR,
        thickness: 1.0,
        indent: 20.0,
        endIndent: 20.0,
      ),
      SizedBox(
        height: 5.0,
      ),
      _getPickupWidget(context),
      SizedBox(
        height: 15.0,
      ),
      dateTextWidget,
      SizedBox(
        height: 5.0,
      ),
      GestureDetector(
        onTap: () => _selectDate(context),
        child: Center(
          child: Container(
            height: 50,
            width: mediaQuery.size.width / 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(1.0)),
              color: ProjectConstants.BUTTON_BACKGROUND_COLOR,
            ),
            child: Center(
              child: Text(
                "Выберите дату",
                style: TextStyle(
                  fontSize: 18 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.BUTTON_TEXT_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Divider(
        color: ProjectConstants.DEFAULT_STROKE_COLOR,
        thickness: 1.0,
        indent: 20.0,
        endIndent: 20.0,
      ),
      SizedBox(
        height: 10.0,
      ),
      GestureDetector(
        onTap: () => _onConfirmButtonPressed(context),
        child: Center(
          child: Container(
            height: 50,
            width: mediaQuery.size.width / 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(1.0)),
              color: ProjectConstants.BUTTON_BACKGROUND_COLOR,
            ),
            child: Center(
              child: Text(
                "Продолжить",
                style: TextStyle(
                  fontSize: 18 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.BUTTON_TEXT_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    ];

    if (_isCourierSelected) {
      children.removeAt(0);
      children.insertAll(0, <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Text(
            "Введите адрес доставки",
            style: TextStyle(
              fontSize: 18 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _getStreetInputWidget(mediaQuery),
                SizedBox(
                  height: 5.0,
                ),
                _getHouseNumInputWidget(mediaQuery),
                SizedBox(
                  height: 5.0,
                ),
                _getRoomNumInputWidget(mediaQuery),
                SizedBox(
                  height: 5.0,
                ),
                _getCommentInputWidget(mediaQuery),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
      ]);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
