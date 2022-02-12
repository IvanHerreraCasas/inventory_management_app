import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/providers/providers.dart';
import 'package:inventory_management_app/ui/common_widgets/search_bar.dart';
import 'package:inventory_management_app/ui/common_widgets/delete_dialog.dart';
import 'package:inventory_management_app/ui/home/categories/widgets/add_category_dialog.dart';
import 'package:inventory_management_app/ui/home/categories/widgets/category_widget.dart';
import 'package:inventory_management_app/ui/home/categories/products.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  String textQuery = '';  

  @override
  Widget build(BuildContext context) {
    final categoriesAsyncValue = ref.watch(categoriessProvider(textQuery));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categorias',
                style: TextStyle(fontSize: 24),
              ),
              IconButton(
                  onPressed: () => showDialog(
                        context: context,
                        builder: (context) => SaveCategoryDialog(
                          onAddCategory: (name) => ref.read(databaseProvider).saveCategory(name: name),
                        ),
                      ),
                  icon: const Icon(Icons.add)),
            ],
          ),
          SearchBar(
            onSubmitted: (value) => setState(() => textQuery = value),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: categoriesAsyncValue.when(
              data: (categories) => ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryWidget(
                    name: category.name,
                    onTap: () {
                      ref.read(categoryProvider.state).state = category;
                      pushNewScreen(
                        context,
                        screen: const Products(),
                        withNavBar: true,
                      );
                    },
                    onDelete: () => showDialog(
                      context: context,
                      builder: (context) => DeleteDialog(
                        onDelete: () => ref.read(databaseProvider).deleteCategory(category.id),
                        title: 'Está seguro que desea eliminar la categoria?',
                        description: 'Al eliminarla también se eliminaran los productos correspondientes',
                      ),
                    ),
                    onEdit: () => showDialog(
                      context: context,
                      builder: (context) => SaveCategoryDialog(
                        onAddCategory: (String name) => ref.read(databaseProvider).saveCategory(
                              id: category.id,
                              name: name,
                            ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 10),
              ),
              error: (error, stack) => const Center(child: Text('Algo salio mal')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
