import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/models/models.dart';
import 'package:inventory_management_app/services/database.dart';
import 'package:inventory_management_app/services/firestore_database.dart';

final dateTimeProvider = StateProvider((ref) {
  final year = DateTime.now().year;
  final month = DateTime.now().month;
  final day = DateTime.now().day;
  return DateTime(year, month, day);
});

final categoryProvider = StateProvider<Category>((ref) => const Category(id: '', name: ''));

final databaseProvider = Provider<Database>((ref) => FirestoreDatabase());

final categoriessProvider = StreamProvider.autoDispose.family<List<Category>, String>(
  (ref, textQuery) {
    final database = ref.watch(databaseProvider);
    return database.streamCategories(textQuery);
  },
);

final productsProvider = StreamProvider.autoDispose.family<List<Product>, String>(
  (ref, textQuery) {
    final database = ref.watch(databaseProvider);
    final categoryID = ref.watch(categoryProvider).id;
    return database.streamProducts(categoryID, textQuery);
  },
);

final salesProvider = StreamProvider.autoDispose(
  (ref) {
    final dataBase = ref.watch(databaseProvider);
    final utcDateTime = ref.watch(dateTimeProvider).toUtc();

    return dataBase.streamSales(utcDateTime);
  },
);

final purchasesProvider = StreamProvider.autoDispose(
  (ref) {
    final dataBase = ref.watch(databaseProvider);
    final dateTime = ref.watch(dateTimeProvider);

    return dataBase.streamPurchases(dateTime.toUtc());
  },
);
