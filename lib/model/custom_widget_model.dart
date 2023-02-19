import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  late int selectedIndex;

  CustomAppBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Icon([Icons.call, Icons.home, Icons.message][selectedIndex]),
      title: Text(['Call', 'The Voice', 'Message'][selectedIndex]),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.account_circle))],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CustomNavigationBar extends StatelessWidget {
  late int selectedIndex;

  CustomNavigationBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.call_outlined),
          label: 'Call',
        ),
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.message_outlined),
          label: 'Message',
        ),
      ],
    );
  }
}
