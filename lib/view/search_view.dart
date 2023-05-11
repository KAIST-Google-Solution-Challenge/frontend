import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/search_controller.dart';
import 'package:the_voice/model/build_model.dart';
import 'package:the_voice/model/setting_model.dart';

class SearchView extends StatefulWidget {
  final String text;
  const SearchView({super.key, required this.text});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  SearchController searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return FutureBuilder(
      future: searchController.search(widget.text),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Scaffold(
              appBar: BuildAppBar(
                pushed: true,
                colored: false,
                title: widget.text,
              ),
              body: Center(
                child: Text(
                  'NO DATA',
                  style: textTheme.headlineLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            );
          } else {
            return Consumer<SettingModel>(
              builder: (context, value, child) => Scaffold(
                appBar: BuildAppBar(
                  pushed: true,
                  colored: false,
                  title: widget.text,
                ),
                body: ListView(
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => CustomHistory(
                      probability: snapshot.data![index]['probability'],
                      date: snapshot.data![index]['timestamp'],
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            appBar: BuildAppBar(
              pushed: true,
              colored: false,
              title: widget.text,
            ),
            body: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: colorScheme.primary,
                size: 32,
              ),
            ),
          );
        }
      },
    );
  }
}
