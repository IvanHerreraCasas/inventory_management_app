import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({
    Key? key,
    required this.onDelete,
    required this.productName,
    required this.units,
    required this.productPrice,
    required this.total,
  }) : super(key: key);

  final Function() onDelete;
  final String productName;
  final int units;
  final double productPrice;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Material(
      //textStyle: Theme.of(context).textTheme,
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 1 / 5,
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              icon: Icons.delete,
            )
          ],
        ),
        child: ExpandablePanel(
          header:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Producto:'),
              Text(productName),
            ],
          ),
          collapsed: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:'),
                    Text(NumberFormat.simpleCurrency().format(total)),
                  ],
                ),
          ),
          expanded: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Unidades:'),
                    Text(units.toString()),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Precio unitario:'),
                    Text(NumberFormat.simpleCurrency().format(productPrice)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:'),
                    Text(NumberFormat.simpleCurrency().format(total)),
                  ],
                ),
              ],
            ),
          ),
          theme: const ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
          ),
        ),
      ),
    );
  }
}
