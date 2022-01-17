import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_management_app/models/models.dart';

class FirestoreReferences {
  static CollectionReference<Category> categoriesRef() =>
      FirebaseFirestore.instance.collection('categories').withConverter<Category>(
            fromFirestore: (snapshot, _) => Category.fromJson(snapshot.data() ?? {}),
            toFirestore: (category, _) => category.toJson(),
          );

  static CollectionReference<Product> productsRef(String categoryID) =>
      FirebaseFirestore.instance.collection('categories/$categoryID/products').withConverter(
            fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data() ?? {}),
            toFirestore: (product, _) => product.toJson(),
          );

  static CollectionReference<Sale> salesRef() => FirebaseFirestore.instance.collection('sales').withConverter(
        fromFirestore: (snapshot, _) => Sale.fromJson(snapshot.data() ?? {}),
        toFirestore: (sale, _) => sale.toJson(),
      );

  static CollectionReference<Purchase> purchasesRef() =>
      FirebaseFirestore.instance.collection('purchases').withConverter(
            fromFirestore: (snapshot, _) => Purchase.fromJson(snapshot.data() ?? {}),
            toFirestore: (purchase, _) => purchase.toJson(),
          );
}
