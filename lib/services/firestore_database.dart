import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_management_app/models/models.dart';
import 'package:inventory_management_app/services/database.dart';
import 'package:inventory_management_app/services/firestore_references.dart';

class FirestoreDatabase implements Database {
  @override
  Future<void> saveCategory({String? id, required String name}) async {
    final categoryDocRef = FirestoreReferences.categoriesRef().doc(id);
    final category = Category(id: categoryDocRef.id, name: name);
    await categoryDocRef.set(category);
  }

  @override
  Future<void> saveProduct({
    String? id,
    required String categoryID,
    required String name,
    required double purchasePrice,
    required double salePrice,
    required int stock,
  }) async {
    final productReference = FirestoreReferences.productsRef(categoryID).doc(id);
    final product = Product(
      id: productReference.id,
      //categoryID: categoryID,
      name: name,
      purchasePrice: purchasePrice,
      salePrice: salePrice,
      stock: stock,
    );
    await productReference.set(product);
  }

  @override
  Future<void> addPurchase({
    required int units,
    required String productID,
    required String categoryID,
    required String productName,
    required double productPrice,
    required DateTime utcDateTime,
  }) async {
    final purchaseRef = FirestoreReferences.purchasesRef().doc();
    final purchase = Purchase(
      id: purchaseRef.id,
      units: units,
      productID: productID,
      categoryID: categoryID,
      productName: productName,
      productPrice: productPrice,
      date: utcDateTime,
    );

    final productReference = FirestoreReferences.productsRef(categoryID).doc(productID);
    final product = await productReference.get();
    final int stock = product.data()!.stock + units;

    await productReference.update({'stock': stock});
    await purchaseRef.set(purchase);
  }

  @override
  Future<void> addSale({
    required int units,
    required String productID,
    required String categoryID,
    required String productName,
    required double productPrice,
    required DateTime utcDateTime,
  }) async {
    final salesRef = FirestoreReferences.salesRef().doc();
    final sale = Sale(
      id: salesRef.id,
      units: units,
      productID: productID,
      categoryID: categoryID,
      productName: productName,
      productPrice: productPrice,
      date: utcDateTime,
    );
    final productReference = FirestoreReferences.productsRef(categoryID).doc(productID);
    final product = await productReference.get();
    final int stock = product.data()!.stock - units;

    await productReference.update({'stock': stock});
    await salesRef.set(sale);
  }

  @override
  Stream<List<Category>> streamCategories(String textQuery) {
    late final Stream<QuerySnapshot<Category>> snapshots;
    if (textQuery.isNotEmpty) {
      final String strFrontCode = textQuery.substring(0, textQuery.length - 1);
      final int lastCodeUnit = textQuery.codeUnits.last;
      final limit = strFrontCode + String.fromCharCode(lastCodeUnit + 1);
      snapshots = FirestoreReferences.categoriesRef()
          .where(
            'name',
            isGreaterThanOrEqualTo: textQuery,
            isLessThan: limit,
          )
          .orderBy('name', descending: false)
          .snapshots();
    }else {
      snapshots = FirestoreReferences.categoriesRef().orderBy('name', descending: false).snapshots();
    }
    return snapshots.map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Stream<List<Product>> streamProducts(String categoryID, String textQuery) {
    late final Stream<QuerySnapshot<Product>> snapshots;

    if (textQuery.isNotEmpty) {
      final String strFrontCode = textQuery.substring(0, textQuery.length - 1);
      final int lastCodeUnit = textQuery.codeUnits.last;
      final limit = strFrontCode + String.fromCharCode(lastCodeUnit + 1);
      snapshots = FirestoreReferences.productsRef(categoryID)
          .where(
            'name',
            isGreaterThanOrEqualTo: textQuery,
            isLessThan: limit,
          )
          .orderBy('name', descending: false)
          .snapshots();
    } else {
      snapshots = FirestoreReferences.productsRef(categoryID).orderBy('name', descending: false).snapshots();
    }

    return snapshots.map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Stream<List<Purchase>> streamPurchases(DateTime dateTime) {
    final snapshots = FirestoreReferences.purchasesRef()
        .where('date', isGreaterThanOrEqualTo: dateTime, isLessThan: dateTime.add(const Duration(days: 1)))
        .snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Stream<List<Sale>> streamSales(DateTime dateTime) {
    final snapshots = FirestoreReferences.salesRef()
        .where('date', isGreaterThanOrEqualTo: dateTime, isLessThan: dateTime.add(const Duration(days: 1)))
        .snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Future<void> deleteCategory(String id) async {
    await FirestoreReferences.categoriesRef().doc(id).delete();
  }

  @override
  Future<void> deleteProduct(String id, String categoryID) async {
    await FirestoreReferences.productsRef(categoryID).doc(id).delete();
  }

  @override
  Future<void> deletePurchase(String id) async {
    final purchaseRef = FirestoreReferences.purchasesRef().doc(id);
    final purchase = await purchaseRef.get();
    final purchaseData = purchase.data()!;
    final categoryID = purchaseData.categoryID;
    final productID = purchaseData.productID;

    if (categoryID != null && productID != null) {
      final productRef = FirestoreReferences.productsRef(categoryID).doc(productID);
      final product = await productRef.get();
      if (product.data() != null) {
        final int stock = product.data()!.stock - purchaseData.units;
        await productRef.update({'stock': stock});
      }
    }

    await purchaseRef.delete();
  }

  @override
  Future<void> deleteSale(String id) async {
    final saleRef = FirestoreReferences.salesRef().doc(id);
    final sale = await saleRef.get();
    final saleData = sale.data()!;
    final categoryID = saleData.categoryID;
    final productID = saleData.productID;

    if (categoryID != null && productID != null) {
      final productRef = FirestoreReferences.productsRef(categoryID).doc(productID);
      final product = await productRef.get();
      if (product.data() != null) {
        final int stock = product.data()!.stock + saleData.units;
        await productRef.update({'stock': stock});
      }
    }

    await saleRef.delete();
  }
}
