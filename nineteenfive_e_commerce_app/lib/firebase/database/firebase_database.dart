/// Firebase Query for fetch product data, update data, fetch user data

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nineteenfive_e_commerce_app/models/category.dart';
import 'package:nineteenfive_e_commerce_app/models/product.dart';
import 'package:nineteenfive_e_commerce_app/models/user_data.dart';

class FirebaseDatabase {

  //For storing user data while sign up
  static Future<void> storeUserData(UserData userData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.userId)
        .set(userData.toJson());
  }

  //Fetch user data according user id
  static Future<UserData> getUserData(String userId) async {
    late UserData userData;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
            userData = UserData.fromJson(value.data()??{});
    });
    return userData;
  }

  // update product detail by product id 
  static Future<void> storeProduct(Product? product) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(product!.productId)
        .set(product.toJson());
  }


  // Fetch products
  static Future<List<Product>> fetchProducts() async {
    List<Product> products = [];
    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        print(element.data());
        products.add(Product.fromJson(element.data()));
      });
    });
    return products;
  }


  // Fetch Categories 
  static Future<List<Category>> fetchCategories() async {
    List<Category> categories = [];
    FirebaseFirestore.instance
        .collection('categories')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        categories.add(Category.fromJson(element.data()));
      });
    });
    return categories;
  }


}
