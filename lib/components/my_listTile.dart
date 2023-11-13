// ignore: file_names
import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
