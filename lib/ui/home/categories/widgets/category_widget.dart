import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    Key? key,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    required this.name,
  }) : super(key: key);

  final void Function() onTap;
  final void Function() onDelete;
  final void Function() onEdit;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 1 / 3,
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              icon: Icons.delete,
            ),
            SlidableAction(
              onPressed: (context) => onEdit(),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              icon: Icons.edit,
            ),
          ],
        ),
        child: ListTile(
          title: Text(name),
          onTap: onTap,
        ),
      ),
    );
  }
}
