import 'package:flutter/material.dart';

class SaveCategoryDialog extends StatelessWidget {
  const SaveCategoryDialog({Key? key, required this.onAddCategory}) : super(key: key);

  final Function(String name) onAddCategory;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        decoration: const InputDecoration(hintText: 'Categoria'),
        onSubmitted: (value) {
          onAddCategory(value);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Categoria guardada'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(milliseconds: 500),
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
