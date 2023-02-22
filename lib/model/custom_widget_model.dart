import 'package:flutter/material.dart';
import 'package:the_voice/model/chart_model.dart';
import 'package:the_voice/view/chat_view.dart';
import 'package:the_voice/view/convert_dialog_view.dart';
import 'package:the_voice/view/call_view.dart';
import 'package:the_voice/view/home_view.dart';
import 'package:the_voice/view/message_view.dart';
import 'package:the_voice/view/profile_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBack;
  final bool isSurface;
  final String data;

  CustomAppBar({
    super.key,
    required this.isBack,
    required this.isSurface,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (isBack) {
      return AppBar(
        backgroundColor: isSurface
            ? colorScheme.surface
            : ElevationOverlay.applySurfaceTint(
                colorScheme.background,
                colorScheme.surfaceTint,
                1,
              ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(data),
      );
    } else {
      return AppBar(
        backgroundColor: isSurface
            ? colorScheme.surface
            : ElevationOverlay.applySurfaceTint(
                colorScheme.background,
                colorScheme.surfaceTint,
                1,
              ),
        title: Row(
          children: [
            SizedBox(width: 8),
            Text(data),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, ProfileView.route),
                icon: Icon(Icons.account_circle),
              ),
              SizedBox(width: 8),
            ],
          ),
        ],
      );
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;

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

// Todo: Implement CustomSearch Functionality
class CustomSearch extends StatelessWidget {
  final String hintText;

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
  final bool isCall;
  final bool isDate;
  final bool isName;

  CustomListTile({
    super.key,
    required this.isCall,
    required this.isDate,
    required this.isName,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    void onTap() {
      isCall
          ? showDialog(
              context: context,
              builder: (context) => ConvertDialogView(isName: isName),
            )
          : Navigator.pushNamed(context, ChatView.route);
    }

    if (isDate && isName) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Date', style: textTheme.labelMedium),
          ),
          ListTile(
            leading: CircleAvatar(radius: 32),
            title: Text('Name'),
            subtitle: Text('010-0000-0000'),
            trailing: Text('Time'),
            onTap: () => onTap(),
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
            leading: CircleAvatar(radius: 32),
            title: Text('010-0000-0000'),
            trailing: Text('Time'),
            onTap: () => onTap(),
          ),
        ],
      );
    } else if (isName) {
      return ListTile(
        leading: CircleAvatar(radius: 32),
        title: Text('Name'),
        subtitle: Text('010-0000-0000'),
        trailing: Text('Time'),
        onTap: () => onTap(),
      );
    } else {
      return ListTile(
        leading: CircleAvatar(radius: 32),
        title: Text('010-0000-0000'),
        trailing: Text('Time'),
        onTap: () => onTap(),
      );
    }
  }
}

class CustomChat extends StatelessWidget {
  final bool isLeft;
  final String data;

  CustomChat({super.key, required this.isLeft, required this.data});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (isLeft) {
      return Column(
        children: [
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    color: colorScheme.surface),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(data),
                ),
              ),
            ],
          )
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  color: colorScheme.primary.withAlpha(13),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(data),
                ),
              ),
              SizedBox(width: 16),
            ],
          )
        ],
      );
    }
  }
}

class CustomChatAnalysis extends StatelessWidget {
  final bool isLeft;
  final String data;
  final double probability;

  CustomChatAnalysis({
    super.key,
    required this.isLeft,
    required this.data,
    required this.probability,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    if (isLeft) {
      return Column(
        children: [
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    color: colorScheme.surface),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(data),
                ),
              ),
              SizedBox(width: 4),
              DoughnutChart(isChat: true, radius: 10, probability: probability),
              SizedBox(width: 4),
              Text(
                '$probability%',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          )
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$probability%',
                style: textTheme.bodyMedium,
              ),
              SizedBox(width: 4),
              DoughnutChart(isChat: true, radius: 10, probability: probability),
              SizedBox(width: 4),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  color: colorScheme.primary.withAlpha(13),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    data,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
            ],
          )
        ],
      );
    }
  }
}
