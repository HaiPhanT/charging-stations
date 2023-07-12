import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Text('First Option',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)))
        ],
      ),
    );
  }
}
