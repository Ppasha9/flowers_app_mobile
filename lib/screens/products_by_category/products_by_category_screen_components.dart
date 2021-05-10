import 'package:flutter/material.dart';
import 'package:orlove_app/screens/components/product_element_widget.dart';

class ProductByCategoryScreenComponent extends StatelessWidget {
  final String category;
  final dynamic leftPrJson;
  final dynamic rightPrJson;

  const ProductByCategoryScreenComponent({
    this.category,
    this.leftPrJson,
    this.rightPrJson: null,
  });

  Widget _getRowContainer(MediaQueryData mediaQuery) {
    final children = <Widget>[];

    children.add(
      Container(
        alignment: Alignment.centerLeft,
        width: mediaQuery.size.width / 2,
        child: Container(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(
              right: 10.0,
            ),
            child: ProductsListElementWidget(
              data: leftPrJson,
            ),
          ),
        ),
      ),
    );

    if (rightPrJson != null) {
      children.add(
        Container(
          alignment: Alignment.centerRight,
          width: mediaQuery.size.width / 2,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(
                left: 10.0,
              ),
              child: ProductsListElementWidget(
                data: rightPrJson,
              ),
            ),
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
    final mediaQuery = MediaQuery.of(context);

    return Container(
      child: _getRowContainer(mediaQuery),
    );
  }
}
