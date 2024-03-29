///Static data like user data, all products data, all categories list, shipping charge

import 'package:nineteenfive_e_commerce_app/models/category.dart';
import 'package:nineteenfive_e_commerce_app/models/product.dart';
import 'package:nineteenfive_e_commerce_app/models/promo_code.dart';
import 'package:nineteenfive_e_commerce_app/models/user_data.dart';

class StaticData {
  static List<Category> categoriesList = [];
  static late UserData userData;
  static List<Product> products = []; 
  static List<PromoCode> promoCodes = [];
  static int shippingCharge = 0;
}
