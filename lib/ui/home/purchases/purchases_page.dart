import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/providers/providers.dart';
import 'package:inventory_management_app/ui/common_widgets/date_widget.dart';
import 'package:inventory_management_app/ui/common_widgets/delete_dialog.dart';
import 'package:inventory_management_app/ui/common_widgets/transaction_widget.dart';

class PurchasesPage extends ConsumerWidget {
  const PurchasesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasesAsyncValue = ref.watch(purchasesProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Compras', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          DateWidget(
            initialdate: ref.watch(dateTimeProvider),
            onDatePicked: (datePicked) => ref.read(dateTimeProvider.state).state = datePicked,
          ),
          const SizedBox(height: 20),
          purchasesAsyncValue.when(
            data: (purchases) => Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: purchases.length,
                itemBuilder: (context, index) {
                  final purchase = purchases[index];
                  return TransactionWidget(
                    onDelete: () => showDialog(
                      context: context,
                      builder: (context) => DeleteDialog(
                        onDelete: () => ref.read(databaseProvider).deletePurchase(purchase.id),
                        title: 'Está seguro que desea eliminar la compra?',
                      ),
                    ),
                    productName: purchase.productName,
                    units: purchase.units,
                    productPrice: purchase.productPrice,
                    total: purchase.total,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 10),
              ),
            ),
            error: (error, stack) => const Center(child: Text('Algo salio mal')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
