import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

String _baseURL = 'mobileappdemo.000webhostapp.com';
// class to represent a row from the products table
// note: cid is replaced by category name
class Product {
  int _pid;
  String _name;
  int _quantity;
  double _price;
  String _category;

  Product(this._pid, this._name, this._quantity, this._price, this._category);

  @override
  String toString() {
    return """
      PID: $_pid Name: $_name 
      Quantity: $_quantity 
      Price: \$$_price 
      Category: $_category """;
  }
}

// list to hold products retrieved from getProducts
List<Product> products = [];

// asynchronously update _products list
void getProducts(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'getProducts.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5)); // max timeout 5 seconds
    products.clear(); // clear old products
    if (response.statusCode == 200) { // if successful call
      final jsonResponse = convert.jsonDecode(response.body); // create dart json object from json array
      for (var row in jsonResponse) { // iterate over all rows in the json array
        Product p = Product( // create a product object from JSON row object
            int.parse(row['pid']),
            row['name'],
            int.parse(row['quantity']),
            double.parse(row['price']),
            row['category']);
        products.add(p); // add the product object to the _products list
      }
      update(true); // callback update method to inform that we completed retrieving data
    }
  }
  catch(e) {
    print('Error loading data with error ${e.toString()}');
    update(false); // inform through callback that we failed to get data
  }
}


// asynchronously update _products list
void getProductById(Function(String text) update, int pid) async {
  try {
    final url = Uri.https(_baseURL, 'getProductByID.php', {'pid':'$pid'});
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5)); // max timeout 5 seconds
    if (response.statusCode == 200) { // if successful call
      final jsonResponse = convert.jsonDecode(response.body); // create dart json object from json array
      if(jsonResponse.length == 0)
        update("No product found");
      else{
        for (var row in jsonResponse) { // iterate over all rows in the json array, there should be at most one product as pid is a primary key
          Product p = Product( // create a product object from JSON row object
              int.parse(row['pid']),
              row['name'],
              int.parse(row['quantity']),
              double.parse(row['price']),
              row['category']);
          update(p.toString()); // callback update method to inform that we completed retrieving data
          break;
        }
      }
    }
  }
  catch(e) {
    print('Error loading data with error ${e.toString()}');
    update("Can't load data"); // inform through callback that we failed to get data
  }
}