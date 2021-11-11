import 'models/hcsProduct.dart';

// Class to help convert HCS products returned in JSON format from the DataGov API to a class in dart

class HcsProducts {
  static List<HcsProduct> products = [];
}

List<HcsProduct> fetchProducts(var response) {
  HcsProducts.products = [];
  int i = 0;
  while (i < response.length) {
    final product = HcsProduct(
      productName: response[i]['brand_and_product_name'],
      packageSize: response[i]['package_size'],
    );
    HcsProducts.products.add(product);
    i++;
  }
  // print(products);
  return HcsProducts.products;
}
