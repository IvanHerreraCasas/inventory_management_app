import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/providers/providers.dart';
import 'package:inventory_management_app/ui/common_widgets/search_bar.dart';
import 'package:inventory_management_app/ui/details/details.dart';
import 'package:inventory_management_app/ui/home/categories/widgets/product_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Products extends ConsumerStatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  ConsumerState<Products> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<Products> {
  String textQuery = '';

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(productsProvider(textQuery));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Consumer(
            builder: (context, ref, child) => Text(
              ref.watch(categoryProvider).name,
            ),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () => pushNewScreen(
                context,
                screen: const DetailsPage(),
                withNavBar: false,
              ),
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(
                onSubmitted: (value) => setState(() => textQuery = value),
              ),
              const SizedBox(height: 20),
              productsAsyncValue.when(
                data: (products) => Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: products.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductWidget(
                        onTap: () {
                          pushNewScreen(
                            context,
                            screen: DetailsPage(
                              id: product.id,
                              name: product.name,
                              purchasePrice: product.purchasePrice,
                              salePrice: product.salePrice,
                              stock: product.stock,
                            ),
                            withNavBar: false,
                          );
                        },
                        onAddSale: (units) => ref.watch(databaseProvider).addSale(
                              units: units,
                              productID: product.id,
                              categoryID: ref.read(categoryProvider).id,
                              productName: product.name,
                              productPrice: product.salePrice,
                              utcDateTime: DateTime.now().toUtc(),
                            ),
                        onAddPurchase: (units) => ref.watch(databaseProvider).addPurchase(
                              units: units,
                              productID: product.id,
                              categoryID: ref.read(categoryProvider).id,
                              productName: product.name,
                              productPrice: product.purchasePrice,
                              utcDateTime: DateTime.now().toUtc(),
                            ),
                        name: product.name,
                        salePrice: product.salePrice,
                        stock: product.stock,
                      );
                    },
                  ),
                ),
                error: (error, stack) => const Center(child: Text('Algo salio mal')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
