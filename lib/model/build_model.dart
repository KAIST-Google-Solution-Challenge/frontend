import 'package:flutter/material.dart';
import 'package:the_voice/model/chart_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/convert_dialog_view.dart';
import 'package:the_voice/view/profile_view.dart';
import 'package:the_voice/view/search_view.dart';

class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool pushed; // is pushed by navigator?
  final bool colored; // is appbar colored?
  final String title;

  const BuildAppBar({
    super.key,
    required this.pushed,
    required this.colored,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color surface1 = ElevationOverlay.applySurfaceTint(
      colorScheme.background,
      colorScheme.surfaceTint,
      1,
    );

    if (pushed) {
      return AppBar(
        backgroundColor: colored ? surface1 : colorScheme.surface,
        title: Text(title),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      );
    } else {
      return AppBar(
        backgroundColor: colored ? surface1 : colorScheme.surface,
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, _buildProfileViewRoute()),
            icon: const Icon(Icons.account_circle),
          ),
        ],
      );
    }
  }

  Route _buildProfileViewRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ProfileView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final curveTween = CurveTween(curve: Curves.ease);
        final tween = Tween(begin: begin, end: end).chain(curveTween);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BuildSearch extends StatefulWidget {
  final SettingModel sm;
  const BuildSearch({super.key, required this.sm});

  @override
  State<BuildSearch> createState() => _BuildSearchState();
}

class _BuildSearchState extends State<BuildSearch> {
  String text = '';

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
                        onChanged: (value) => text = value,
                        cursorColor: colorScheme.primary,
                        style: textTheme.bodyLarge,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: widget.sm.language == Language.english
                              ? 'Search phone number'
                              : '전화번호 검색',
                          hintStyle: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchView(text: text),
                      ),
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

class CustomCallListTile extends StatelessWidget {
  final bool isHeader;
  final Widget leading;
  final String header;
  final String title;
  final String subtitle;
  final String trailing;
  final String datetime;

  const CustomCallListTile({
    super.key,
    required this.isHeader,
    required this.leading,
    required this.header,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.datetime,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    void onTap() {
      showDialog(
        context: context,
        builder: (context) => ConvertCallDialogView(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          datetime: datetime,
        ),
      );
    }

    if (isHeader) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(header, style: textTheme.labelMedium),
          ),
          ListTile(
            leading: leading,
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: Text(trailing),
            onTap: () => onTap(),
          ),
        ],
      );
    } else {
      return ListTile(
        leading: leading,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(trailing),
        onTap: () => onTap(),
      );
    }
  }
}

class CustomMessageListTile extends StatelessWidget {
  final int threadId;
  final Widget leading;
  final String title;
  final String subtitle;
  final String trailing;

  const CustomMessageListTile({
    super.key,
    required this.threadId,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    void onTap() {
      showDialog(
        context: context,
        builder: (context) => ConvertMessageDialogView(
          threadId: threadId,
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
        ),
      );
    }

    return ListTile(
      leading: leading,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(trailing),
      onTap: () => onTap(),
    );
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
  final bool isAnalyzed;
  final String data;
  final double probability;

  const CustomChatAnalysis({
    super.key,
    required this.isLeft,
    required this.isAnalyzed,
    required this.data,
    required this.probability,
  });

  String process(String data) {
    List<String> lines = [];

    int cnt = 0;
    String line = "";
    for (int i = 0; i < data.length; i += 1) {
      if (i == data.length - 1) {
        cnt += 1;
        line += data[i];
        lines.add(line);
      } else if (cnt == 20 || data[i] == '\n') {
        lines.add(line);
        cnt = 1;
        line = data[i];
      } else {
        cnt += 1;
        line += data[i];
      }
    }

    return lines.join('\n');
  }

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
                  child: Text(process(data)),
                ),
              ),
              isAnalyzed
                  ? Row(
                      children: [
                        const SizedBox(width: 4),
                        DoughnutChart(
                            isChat: true, radius: 10, probability: probability),
                        const SizedBox(width: 4),
                        Text(
                          '$probability%',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox()
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
              isAnalyzed
                  ? Row(
                      children: [
                        Text(
                          '$probability%',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 4),
                        DoughnutChart(
                            isChat: true, radius: 10, probability: probability),
                        const SizedBox(width: 4),
                      ],
                    )
                  : const SizedBox(),
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
                    process(data),
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
