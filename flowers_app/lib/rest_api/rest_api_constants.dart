class REST_API_CONSTANTS {
  // static const String HOST = "http://192.168.0.105:8080";
  static const String HOST = "https://lavanda-test-server.herokuapp.com";
  static const String PRODUCT_ROOT_URL = "$HOST/api/product";
  static const String CATEGORY_ROOT_URL = "$HOST/api/category";
  static const String AUTH_ROOT_URL = "$HOST/api/auth";
  static const String CART_ROOT_URL = "$HOST/api/cart";
  static const String ORDER_ROOT_URL = "$HOST/api/order";

  static dynamic DEFAULT_REQUEST_HEADERS = {
    "Content-Type": "application/json",
    "Accept": "*/*",
  };
}
