import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionDialog extends StatefulWidget {
  const TransactionDialog({
    Key? key,
    required this.onAddSale,
    required this.onAddPurchase,
  }) : super(key: key);

  final void Function(int units) onAddSale;
  final void Function(int units) onAddPurchase;
  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  int tradingType = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () => setState(() => tradingType = 0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tradingType == 0 ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Venta',
                    style: TextStyle(
                      color: tradingType == 0 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => setState(() => tradingType = 1),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tradingType == 1 ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Compra',
                    style: TextStyle(
                      color: tradingType == 1 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Unidades',
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSubmitted: (value) {
              late String snackBarMessage;
              int units = int.tryParse(value) ?? 0;
              if (tradingType == 0) {
                widget.onAddSale(units);
                snackBarMessage = 'Venta agregada';
              } else {
                widget.onAddPurchase(units);
                snackBarMessage = 'Compra agregada';
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(snackBarMessage),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(milliseconds: 500),
                ),
              );
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
