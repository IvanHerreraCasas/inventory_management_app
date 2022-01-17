import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_app/ui/home/categories/widgets/transaction_dialog.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    Key? key,
    required this.onTap,
    required this.onAddSale,
    required this.onAddPurchase,
    required this.name,
    required this.salePrice,
    required this.stock,
  }) : super(key: key);

  final void Function() onTap;
  final void Function(int units) onAddSale;
  final void Function(int units) onAddPurchase;
  final String name;
  final double salePrice;
  final int stock;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 1,
                child: Text(
                  NumberFormat.simpleCurrency().format(salePrice),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stock: ' + stock.toString(),
                style: const TextStyle(fontSize: 15),
              ),
              InkWell(
                child: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColorLight,
                  ),
                  child: const Icon(
                    Icons.add,
                  ),
                ),
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => TransactionDialog(
                    onAddSale: onAddSale,
                    onAddPurchase: onAddPurchase,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
