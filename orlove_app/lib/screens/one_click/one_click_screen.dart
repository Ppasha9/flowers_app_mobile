import 'package:bottom_loader/bottom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/product_controller.dart';
import 'package:orlove_app/models/cart_model.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_loader.dart';
import 'package:orlove_app/screens/home/home_screen.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';
import 'package:time_machine/time_machine.dart';

class OneClickScreen extends StatefulWidget {
  final dynamic productInfo;
  final List<ProductParameterDTO> productSelectedParams;

  OneClickScreen({
    this.productInfo,
    this.productSelectedParams,
  });

  @override
  _OneClickScreenState createState() => _OneClickScreenState();
}

class _OneClickScreenState extends State<OneClickScreen> {
  final _formReceiverKey = GlobalKey<FormState>();
  final _receiverNameTextController = TextEditingController();
  final _receiverSurnameTextController = TextEditingController();
  final _receiverPhoneTextController = TextEditingController();
  final _receiverEmailTextController = TextEditingController();

  final _formShippmentKey = GlobalKey<FormState>();
  bool _isPickupSelected = true;
  bool _isCourierSelected = false;
  final _streetTextController = TextEditingController();
  final _houseNumTextController = TextEditingController();
  final _roomTextController = TextEditingController();
  final _commentTextController = TextEditingController();

  bool _isOnlineSelected = false;
  bool _isCashSelected = true;

  DateTime selectedDate = null;

  BottomLoader bottomLoader;

  Widget _getNameInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _receiverNameTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Имя*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: InputBorder.none,
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

  Widget _getSurnameInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _receiverSurnameTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Фамилия*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: InputBorder.none,
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

  Widget _getPhoneInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: _receiverPhoneTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Телефон*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: InputBorder.none,
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

  Widget _getEmailInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _receiverEmailTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Почта*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: InputBorder.none,
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
      validator: MultiValidator(
        [
          RequiredValidator(
            errorText: "Это поле обязательно к заполнению",
          ),
          EmailValidator(
            errorText: "Неверный адрес почты",
          ),
        ],
      ),
    );
  }

  Widget _getReceiverInfoWidget(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Form(
      key: _formReceiverKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Text(
              "Получатель",
              style: TextStyle(
                fontSize: 16 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                fontWeight: FontWeight.w600,
                color: ProjectConstants.APP_FONT_COLOR,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getNameInputWidget(mediaQuery),
                Divider(
                  height: 5.0,
                  thickness: 1,
                ),
                _getSurnameInputWidget(mediaQuery),
                Divider(
                  height: 5.0,
                  thickness: 1,
                ),
                _getPhoneInputWidget(mediaQuery),
                Divider(
                  height: 5.0,
                  thickness: 1,
                ),
                _getEmailInputWidget(mediaQuery),
                Divider(
                  height: 5.0,
                  thickness: 1,
                ),
              ],
            ),
          ),
        ],
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
        border: InputBorder.none,
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
        border: InputBorder.none,
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
        border: InputBorder.none,
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
        hintText: "Комментарий",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: InputBorder.none,
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
    );
  }

  Widget _getAddressWidget(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    if (_isPickupSelected) {
      return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Text(
          "Самовывоз с адреса: г. СПб, ул. Варшавская, д. 59",
          style: TextStyle(
            fontSize: 14 * mediaQuery.textScaleFactor,
            fontFamily: ProjectConstants.APP_FONT_FAMILY,
            color: ProjectConstants.APP_FONT_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Form(
      key: _formShippmentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getStreetInputWidget(mediaQuery),
                Divider(
                  height: 5.0,
                  thickness: 1,
                ),
                _getHouseNumInputWidget(mediaQuery),
                Divider(
                  height: 5.0,
                  thickness: 1,
                ),
                _getRoomNumInputWidget(mediaQuery),
                Divider(
                  height: 5.0,
                  thickness: 1,
                ),
                _getCommentInputWidget(mediaQuery),
                Divider(
                  height: 5.0,
                  thickness: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    DateTime pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        DateTime tmpPickedDate;
        return Container(
          height: mediaQuery.size.height / 4,
          width: mediaQuery.size.width,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text(
                        'Отмена',
                        style: TextStyle(
                          fontSize: 14 * mediaQuery.textScaleFactor,
                          fontFamily: ProjectConstants.APP_FONT_FAMILY,
                          color: ProjectConstants.BUTTON_TEXT_COLOR,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: Text(
                        'Готово',
                        style: TextStyle(
                          fontSize: 14 * mediaQuery.textScaleFactor,
                          fontFamily: ProjectConstants.APP_FONT_FAMILY,
                          color: ProjectConstants.BUTTON_TEXT_COLOR,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(tmpPickedDate);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime:
                        selectedDate != null ? selectedDate : DateTime.now(),
                    onDateTimeChanged: (DateTime dateTime) {
                      tmpPickedDate = dateTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Widget _getShippmentAddressInfoWidget(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    Widget dateTextWidget = selectedDate != null
        ? Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Text(
              "Дата выдачи(доставки) заказа: ${selectedDate.day} ${Utils.getMonthStringFromNumber(selectedDate.month)} ${selectedDate.year}",
              style: TextStyle(
                fontSize: 18 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Text(
            "Выберите способ доставки",
            style: TextStyle(
              fontSize: 16 * mediaQuery.textScaleFactor,
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
          thickness: 1.0,
          indent: 20.0,
          endIndent: 20.0,
        ),
        SizedBox(
          height: 5.0,
        ),
        _getPickupWidget(context),
        SizedBox(
          height: 20.0,
        ),
        _getAddressWidget(context),
        SizedBox(
          height: 10.0,
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
      ],
    );
  }

  Widget _getOnlinePaymentWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        setState(
          () {
            _isOnlineSelected = !_isOnlineSelected;
            if (_isOnlineSelected && _isCashSelected) {
              _isCashSelected = !_isCashSelected;
            }
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isOnlineSelected
                      ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                      : ProjectConstants.APP_FONT_COLOR,
                  width: 2.0,
                ),
                color: _isOnlineSelected
                    ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                    : ProjectConstants.BACKGROUND_SCREEN_COLOR,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              "Банковской картой / Apple Pay",
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

  Widget _getCashPaymentWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        setState(
          () {
            _isCashSelected = !_isCashSelected;
            if (_isCashSelected && _isOnlineSelected) {
              _isOnlineSelected = !_isOnlineSelected;
            }
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isCashSelected
                      ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                      : ProjectConstants.APP_FONT_COLOR,
                  width: 2.0,
                ),
                color: _isCashSelected
                    ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                    : ProjectConstants.BACKGROUND_SCREEN_COLOR,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              "Наличными курьеру",
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

  Widget _getPaymentInfoWidget(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Text(
            "Введите способ оплаты",
            style: TextStyle(
              fontSize: 16 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        _getOnlinePaymentWidget(context),
        SizedBox(
          height: 5.0,
        ),
        Divider(
          thickness: 1.0,
          indent: 20.0,
          endIndent: 20.0,
        ),
        SizedBox(
          height: 5.0,
        ),
        _getCashPaymentWidget(context),
      ],
    );
  }

  Widget _getProductParametersWidget(
      MediaQueryData mediaQuery, dynamic prInfo) {
    List<ProductParameterDTO> parameters = widget.productSelectedParams != null
        ? widget.productSelectedParams
        : [];
    if (parameters == []) {
      return Container();
    }

    List<Widget> children = [];
    parameters.forEach((ProductParameterDTO el) {
      children.add(
        Container(
          child: Row(
            children: [
              Text(
                "${el.parameterName}: ${el.parameterValue} (+ ${el.parameterPrice.round()} Руб.)",
                style: TextStyle(
                  fontSize: 12 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });

    return Container(
      child: Column(
        children: children,
      ),
    );
  }

  Widget _getProductCardWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.15,
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: constraints.maxWidth * 0.30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.productInfo["pictures"][0]["url"],
                    ),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${Utils.fromUTF8(widget.productInfo["name"])}\n${Utils.getPriceCorrectString(widget.productInfo["price"].round())} Руб.",
                      style: TextStyle(
                        fontSize: 14 * mediaQuery.textScaleFactor,
                        fontFamily: ProjectConstants.APP_FONT_FAMILY,
                        color: ProjectConstants.APP_FONT_COLOR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _getProductParametersWidget(mediaQuery, widget.productInfo),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _getProductInfoWidget(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Text(
            "Состав заказа",
            style: TextStyle(
              fontSize: 16 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: _getProductCardWidget(context),
        ),
      ],
    );
  }

  Widget _getFinalPriceWidget(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    int cartPrice = widget.productInfo["price"].round();
    int shippmentPrice = _isCourierSelected ? 300 : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Text(
            "Финальная стоимость",
            style: TextStyle(
              fontSize: 16 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Общая стоимость",
                    style: TextStyle(
                      fontSize: 14 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      color: ProjectConstants.APP_FONT_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "${Utils.getPriceCorrectString(cartPrice)} Руб.",
                    style: TextStyle(
                      fontSize: 14 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      color: ProjectConstants.APP_FONT_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Доставка",
                    style: TextStyle(
                      fontSize: 14 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      color: ProjectConstants.APP_FONT_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "$shippmentPrice Руб.",
                    style: TextStyle(
                      fontSize: 14 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      color: ProjectConstants.APP_FONT_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Итого к оплате",
                    style: TextStyle(
                      fontSize: 14 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      color: ProjectConstants.APP_FONT_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "${Utils.getPriceCorrectString(cartPrice + shippmentPrice)} Руб.",
                    style: TextStyle(
                      fontSize: 14 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      color: ProjectConstants.APP_FONT_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future _onConfirmButtonPressed(BuildContext context) async {
    final receiverValidateRes = _formReceiverKey.currentState.validate();
    if (!receiverValidateRes) {
      if (bottomLoader.isShowing()) {
        bottomLoader.close();
      }

      return;
    }

    if (!_isCourierSelected && !_isPickupSelected) {
      Fluttertoast.showToast(msg: "Нужно обязательно выбрать способ доставки!");
      return;
    }

    if (_isCourierSelected) {
      final shippmentReceiverKey = _formShippmentKey.currentState.validate();
      if (!shippmentReceiverKey) {
        if (bottomLoader.isShowing()) {
          bottomLoader.close();
        }

        return;
      }
    }

    if (!_isOnlineSelected && !_isCashSelected) {
      Fluttertoast.showToast(msg: "Нужно обязательно выбрать способ оплаты!");
      return;
    }

    if (selectedDate == null) {
      Fluttertoast.showToast(msg: "Пожалуйста, выберите дату");
      return;
    }

    if (!bottomLoader.isShowing()) {
      bottomLoader.display();
    }

    var localDateTime = new LocalDateTime.dateTime(selectedDate.toLocal());
    Map<String, dynamic> reqBody = {
      "productId": widget.productInfo["id"],
      "receiverName":
          Utils.fromUTF8(_receiverNameTextController.text.toString()),
      "receiverSurname":
          Utils.fromUTF8(_receiverSurnameTextController.text.toString()),
      "receiverPhone": _receiverPhoneTextController.text.toString(),
      "receiverEmail": _receiverEmailTextController.text.toString(),
      "receiverStreet":
          _isCourierSelected ? _streetTextController.text.toString() : "",
      "receiverHouseNum":
          _isCourierSelected ? _houseNumTextController.text.toString() : "",
      "receiverApartmentNum":
          _isCourierSelected ? _roomTextController.text.toString() : "",
      "deliveryComment":
          _isCourierSelected ? _commentTextController.text.toString() : "",
      "deliveryMethod": _isCourierSelected ? "courier" : "pickup",
      "paymentMethod": _isCashSelected ? "cash" : "online",
      "deliveryDate": OffsetDateTime(localDateTime, Offset(3)).toString(),
      "parameters": widget.productSelectedParams,
    };

    await ProductController.createOneClickOrder(reqBody);

    if (bottomLoader.isShowing()) {
      bottomLoader.close();
    }

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => HomeScreen(),
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    bottomLoader = getBottomLoader(context);
    MediaQueryData mediaQuery = MediaQuery.of(context);

    if (SecureStorage.isLogged) {
      _receiverNameTextController.text = Utils.fromUTF8(SecureStorage.name);
      _receiverEmailTextController.text = SecureStorage.email;
      _receiverPhoneTextController.text = SecureStorage.phone;
      _receiverSurnameTextController.text =
          Utils.fromUTF8(SecureStorage.surname);
    }

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 10.0,
              ),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: ProjectConstants.APP_FONT_COLOR,
                  size: 35.0,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            _getReceiverInfoWidget(context),
            SizedBox(
              height: 30.0,
            ),
            _getShippmentAddressInfoWidget(context),
            SizedBox(
              height: 20.0,
            ),
            _getPaymentInfoWidget(context),
            SizedBox(
              height: 20.0,
            ),
            _getProductInfoWidget(context),
            SizedBox(
              height: 20.0,
            ),
            _getFinalPriceWidget(context),
            SizedBox(
              height: 20.0,
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
            SizedBox(
              height: 5.0,
            ),
            Center(
              child: Text(
                "при подтверждении заказы, вы соглашаетесь с\nПолитикой конфиденциальности и с условиями публичной офертой",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  fontSize: 10 * mediaQuery.textScaleFactor,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      body: _getBodyWidget(context),
      appBar: getAppBar(context),
    );
  }
}
