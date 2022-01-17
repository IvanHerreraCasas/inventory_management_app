import 'package:inventory_management_app/models/models.dart';

abstract class Database {
  Stream<List<Category>> streamCategories(String textQuery);

  Stream<List<Product>> streamProducts(String categoryID, String textQuery);

  Stream<List<Sale>> streamSales(DateTime dateTime);

  Stream<List<Purchase>> streamPurchases(DateTime dateTime);

  Future<void> saveProduct({
    String? id,
    required String categoryID,
    required String name,
    required double purchasePrice,
    required double salePrice,
    required int stock,
  });

  Future<void> saveCategory({
    String? id,
    required String name,
  });

  Future<void> addSale({
    required int units,
    required String productID,
    required String categoryID,
    required String productName,
    required double productPrice,
    required DateTime utcDateTime,
  });

  Future<void> addPurchase({
    required int units,
    required String productID,
    required String categoryID,
    required String productName,
    required double productPrice,
    required DateTime utcDateTime,
  });

  Future<void> deleteProduct(String id, String categoryID);

  Future<void> deleteCategory(String id);

  Future<void> deleteSale(String id);

  Future<void> deletePurchase(String id);
}
