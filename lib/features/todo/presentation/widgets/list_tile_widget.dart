import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text('Bozor qilish'), subtitle: Text('Vaqt'));
  }
}
