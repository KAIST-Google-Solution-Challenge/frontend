import 'package:flutter/material.dart';
import 'package:the_voice/model/chart_model.dart';
import 'package:the_voice/view/chat_view.dart';
import 'package:the_voice/view/convert_dialog_view.dart';
import 'package:the_voice/view/call_view.dart';
import 'package:the_voice/view/home_view.dart';
import 'package:the_voice/view/message_view.dart';
import 'package:the_voice/view/profile_view.dart';
import 'package:the_voice/view/search_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBack;
  final bool isSurface;
  final String data;

  const CustomAppBar({
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
          icon: const Icon(Icons.arrow_back),
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
            const SizedBox(width: 8),
            Text(data),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, ProfileView.route),
                icon: const Icon(Icons.account_circle),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const CustomNavigationBar({
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

  const CustomSearch({
    super.key,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.menu),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      SearchView.route,
                    ),
                  ),
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
  final String date;
  final String name;
  final String number;
  final String time;

  const CustomListTile({
    super.key,
    required this.isCall,
    required this.isDate,
    required this.isName,
    this.date = 'Date',
    this.name = 'Name',
    this.number = '010-0000-0000',
    this.time = 'Time',
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
            padding: const EdgeInsets.all(16),
            child: Text(date, style: textTheme.labelMedium),
          ),
          ListTile(
            leading: const CircleAvatar(radius: 32),
            title: Text(name),
            subtitle: Text(number),
            trailing: Text(time),
            onTap: () => onTap(),
          ),
        ],
      );
    } else if (isDate) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(date, style: textTheme.labelMedium),
          ),
          ListTile(
            leading: const CircleAvatar(radius: 32),
            title: Text(number),
            trailing: Text(time),
            onTap: () => onTap(),
          ),
        ],
      );
    } else if (isName) {
      return ListTile(
        leading: const CircleAvatar(radius: 32),
        title: Text(name),
        subtitle: Text(number),
        trailing: Text(time),
        onTap: () => onTap(),
      );
    } else {
      return ListTile(
        leading: const CircleAvatar(radius: 32),
        title: Text(number),
        trailing: Text(time),
        onTap: () => onTap(),
      );
    }
  }
}

class CustomHistory extends StatelessWidget {
  final double probability;
  final String date;

  const CustomHistory({
    super.key,
    required this.probability,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: DoughnutChart(
        isChat: true,
        radius: 24,
        probability: probability,
      ),
      title: Text('$probability%'),
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 24,
        top: 8,
        bottom: 8,
      ),
      trailing: Text(date),
      onTap: () {},
    );
  }
}

class CustomChat extends StatelessWidget {
  final bool isLeft;
  final String data;

  const CustomChat({super.key, required this.isLeft, required this.data});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (isLeft) {
      return Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    color: colorScheme.surface),
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  color: colorScheme.primary.withAlpha(13),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(data),
                ),
              ),
              const SizedBox(width: 16),
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

  const CustomChatAnalysis({
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    color: colorScheme.surface),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(data),
                ),
              ),
              const SizedBox(width: 4),
              DoughnutChart(isChat: true, radius: 10, probability: probability),
              const SizedBox(width: 4),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$probability%',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(width: 4),
              DoughnutChart(isChat: true, radius: 10, probability: probability),
              const SizedBox(width: 4),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  color: colorScheme.primary.withAlpha(13),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    data,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          )
        ],
      );
    }
  }
}
