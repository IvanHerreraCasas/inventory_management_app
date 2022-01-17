import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/providers/providers.dart';

class DetailsPage extends ConsumerStatefulWidget {
  const DetailsPage({
    Key? key,
    this.id,
    this.name,
    this.purchasePrice,
    this.salePrice,
    this.stock,
  }) : super(key: key);
 
  final String? id;
  final String? name;
  final double? purchasePrice;
  final double? salePrice;
  final int? stock;

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends ConsumerState<DetailsPage> {
  final titleController = TextEditingController();
  final stockController = TextEditingController();
  final purchaseController = TextEditingController();
  final saleController = TextEditingController();

  final titleFocus = FocusNode();
  final stockFocus = FocusNode();
  final purchaseFocus = FocusNode();
  final saleFocus = FocusNode();

  final textSaleValue = StateProvider((ref) => '');
  final textPurchaseValue = StateProvider((ref) => '');

  @override
  void initState() {
    super.initState();
    titleController.text = widget.name ?? '';
    stockController.text = widget.stock?.toString() ?? '';
    purchaseController.text = widget.purchasePrice?.toString() ?? '';
    saleController.text = widget.salePrice?.toString() ?? '';
  }

  @override
  void dispose() {
    titleController.dispose();
    saleController.dispose();
    purchaseController.dispose();
    stockController.dispose();

    titleFocus.dispose();
    saleFocus.dispose();
    purchaseFocus.dispose();
    stockFocus.dispose();

    super.dispose();
  }

  void trySaveProduct() {
    if (titleController.text.isEmpty) {
      titleFocus.requestFocus();
    } else if (stockController.text.isEmpty) {
      stockFocus.requestFocus();
    } else if (purchaseController.text.isEmpty) {
      purchaseFocus.requestFocus();
    } else if (saleController.text.isEmpty) {
      saleFocus.requestFocus();
    } else {
      final category = ref.read(categoryProvider);
      ref.read(databaseProvider).saveProduct(
            categoryID: category.id,
            id: widget.id,
            name: titleController.text,
            purchasePrice: double.parse(purchaseController.text),
            salePrice: double.parse(saleController.text),
            stock: int.parse(stockController.text),
          );
      Navigator.pop(context);
    }
  }

  void tryDeleteProduct() {
    if (widget.id != null) {
      final category = ref.read(categoryProvider);
      ref.read(databaseProvider).deleteProduct(widget.id!, category.id);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: trySaveProduct,
              icon: const Icon(Icons.done),
            ),
            IconButton(
              onPressed: tryDeleteProduct,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                //Title
                TextField(
                  controller: titleController,
                  focusNode: titleFocus,
                  decoration: const InputDecoration(
                    hintText: 'Titulo',
                    hintStyle: TextStyle(fontSize: 18),
                  ),
                  style: const TextStyle(fontSize: 18),
                  onEditingComplete: () => saleFocus.requestFocus(),
                ),
                const SizedBox(height: 20),
                //Sale price
                Row(
                  children: [
                    const Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: Text(
                        'Precio de venta: ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: TextField(
                        controller: saleController,
                        focusNode: saleFocus,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            //allow only expressions like 45.65, not 45.666 or 45..6 or 45.6.
                            RegExp(r'^[0-9]*\.?[0-9]{0,2}$'),
                            replacementString: ref.watch(textSaleValue),
                          ),
                        ],
                        onChanged: (value) => ref.watch(textSaleValue.state).state = value,
                        onEditingComplete: () => purchaseFocus.requestFocus(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                //Purchase price
                Row(
                  children: [
                    const Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: Text(
                        'Precio de compra: ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: TextField(
                        controller: purchaseController,
                        focusNode: purchaseFocus,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            //allow only expressions like 45.65, not 45.666 or 45..6 or 45.6.
                            RegExp(r'^[0-9]*\.?[0-9]{0,2}$'),
                            replacementString: ref.watch(textPurchaseValue),
                          ),
                        ],
                        onChanged: (value) => ref.read(textPurchaseValue.state).state = value,
                        onEditingComplete: () => stockFocus.requestFocus(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                //Stock
                Row(
                  children: [
                    const Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: Text(
                        'Stock: ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: TextField(
                        controller: stockController,
                        focusNode: stockFocus,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
