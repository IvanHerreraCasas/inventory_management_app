import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    Key? key,
    required this.onDelete,
    required this.title,
    this.description,
  }) : super(key: key);

  final Function() onDelete;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: description != null ? Text(description!) : null,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
