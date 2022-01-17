import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/providers/providers.dart';
import 'package:inventory_management_app/ui/common_widgets/date_widget.dart';
import 'package:inventory_management_app/ui/common_widgets/delete_dialog.dart';
import 'package:inventory_management_app/ui/common_widgets/transaction_widget.dart';

class SalesPage extends ConsumerWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsyncValue = ref.watch(salesProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ventas', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          DateWidget(
            initialdate: ref.watch(dateTimeProvider),
            onDatePicked: (datePicked) => ref.read(dateTimeProvider.state).state = datePicked,
          ),
          const SizedBox(height: 20),
          salesAsyncValue.when(
            data: (sales) => Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  final sale = sales[index];
                  return TransactionWidget(
                    onDelete: () => showDialog(
                      context: context,
                      builder: (context) => DeleteDialog(
                        onDelete: () => ref.read(databaseProvider).deleteSale(sale.id),
                        title: 'Está seguro que desea eliminar la venta?',
                      ),
                    ),
                    productName: sale.productName,
                    units: sale.units,
                    productPrice: sale.productPrice,
                    total: sale.total,
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
