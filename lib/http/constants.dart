class HttpConstants {
  static const String SERVER_HOST = "http://212.1.214.199:8080";

  static const String AUTH_PATH = "/api/auth";
  static const String PRODUCT_PATH = "/api/product";
  static const String CATEGORY_PATH = "/api/category";
  static const String CART_PATH = "/api/cart";
  static const String ORDER_PATH = "/api/order";

  static dynamic DEFAULT_REQUEST_HEADERS = {
    "Content-Type": "application/json",
    "Accept": "*/*",
  };
}
