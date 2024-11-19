import 'package:flutter/material.dart';

class IconButtonMenu extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const IconButtonMenu({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, color: Colors.white,),
      onPressed: () {
        scaffoldKey.currentState?.openEndDrawer();
      },
    );
  }
}
