import 'package:flutter/material.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({Key? key, required this.initialdate, required this.onDatePicked}) : super(key: key);

  final Function(DateTime datePicked) onDatePicked;
  final DateTime initialdate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? datePicked = await showDatePicker(
          context: context,
          locale: const Locale('es'),
          initialDate: initialdate,
          firstDate: DateTime(2010),
          lastDate: DateTime(2040),
        );
        if (datePicked != null) {
          onDatePicked(datePicked);
        }
      },
      child: Row(
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 10),
          Text(formatDate(initialdate)),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    var dateString = date.toString().split(' ')[0];
    var elements = dateString.split('-');
    return elements[2] + '/' + elements[1] + '/' + elements[0];
  }
}
