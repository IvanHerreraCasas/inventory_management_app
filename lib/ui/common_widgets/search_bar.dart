import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    required this.onSubmitted,
    required this.onSuffixTap,
  }) : super(key: key);

  final void Function(String textQuery) onSubmitted;
  final void Function() onSuffixTap;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: widget.onSubmitted,      
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        isCollapsed: true,
        isDense: true,
        border: const OutlineInputBorder(),
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        suffix: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            controller.text = '';
            widget.onSuffixTap();
          },
          icon: const Icon(Icons.cancel),
        ),
      ),
    );
  }
}
