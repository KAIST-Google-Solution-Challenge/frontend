import 'package:flutter/material.dart';
import 'package:the_voice/view/call_view.dart';
import 'package:the_voice/view/home_view.dart';
import 'package:the_voice/view/message_view.dart';
import 'package:the_voice/view/profile_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  late bool isMain; // isMain = isCall || isHome || isMessage
  late int selectedIndex;

  CustomAppBar({
    super.key,
    required this.isMain,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (isMain) {
      return AppBar(
        title: Row(
          children: [
            SizedBox(width: 8),
            Text(['Call', 'The Voice', 'Message'][selectedIndex]),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, ProfileView.route),
            icon: Icon(Icons.account_circle),
          )
        ],
      );
    } else {
      return AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Profile'),
      );
    }
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
      onDestinationSelected: (value) => Navigator.pushReplacementNamed(
        context,
        [CallView.route, HomeView.route, MessageView.route][value],
      ),
      destinations: [
        NavigationDestination(
          icon: Icon(selectedIndex == 0 ? Icons.call : Icons.call_outlined),
          label: 'Call',
        ),
        NavigationDestination(
          icon: Icon(selectedIndex == 1 ? Icons.home : Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          icon:
              Icon(selectedIndex == 2 ? Icons.message : Icons.message_outlined),
          label: 'Message',
        ),
      ],
    );
  }
}

class CustomSearch extends StatelessWidget {
  late String hintText;

  CustomSearch({
    super.key,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        height: 56,
        child: Material(
          elevation: 3,
          color: colorScheme.surface,
          shadowColor: colorScheme.shadow,
          surfaceTintColor: colorScheme.surfaceTint,
          borderRadius: BorderRadius.circular(28),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(28),
            highlightColor: Colors.transparent,
            splashFactory: InkRipple.splashFactory,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.menu),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        cursorColor: colorScheme.primary,
                        style: textTheme.bodyLarge,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: hintText,
                          hintStyle: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.search),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  late bool isDate;
  late bool isName;

  CustomListTile({super.key, required this.isDate, required this.isName});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    if (isDate && isName) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Date', style: textTheme.labelMedium),
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Name'),
            subtitle: Text('010-0000-0000'),
            trailing: Text('Time'),
          ),
        ],
      );
    } else if (isDate) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Date', style: textTheme.labelMedium),
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('010-0000-0000'),
            trailing: Text('Time'),
          ),
        ],
      );
    } else if (isName) {
      return ListTile(
        leading: Icon(Icons.image),
        title: Text('Name'),
        subtitle: Text('010-0000-0000'),
        trailing: Text('Time'),
      );
    } else {
      return ListTile(
        leading: Icon(Icons.image),
        title: Text('010-0000-0000'),
        trailing: Text('Time'),
      );
    }
  }
}
