import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/provider/setting_provider.dart';
import 'package:the_voice/view/search_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    SettingProvider sm = context.watch<SettingProvider>();
    bool lang = sm.language == Language.english;

    return Column(
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Text(
          lang ? 'The Voice' : '그놈 목소리',
          style: tt.headlineLarge?.copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: 32),
        const BuildSearch(),
        const Expanded(flex: 4, child: SizedBox()),
      ],
    );
  }
}

class BuildSearch extends StatefulWidget {
  const BuildSearch({super.key});

  @override
  State<BuildSearch> createState() => _BuildSearchState();
}

class _BuildSearchState extends State<BuildSearch> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    SettingProvider sm = context.watch<SettingProvider>();
    bool largeFont = sm.largeFont;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: Material(
          elevation: 3,
          color: cs.surface,
          shadowColor: Colors.transparent,
          surfaceTintColor: cs.surfaceTint,
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
                        cursorColor: cs.primary,
                        style: tt.bodyLarge,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: sm.language == Language.english
                              ? 'Search phone number'
                              : '전화번호 검색',
                          hintStyle: largeFont
                              ? tt.titleLarge?.copyWith(
                                  color: cs.onSurfaceVariant,
                                )
                              : tt.bodyLarge?.copyWith(
                                  color: cs.onSurfaceVariant,
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
