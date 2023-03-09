import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/search_controller.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';

class SearchView extends StatefulWidget {
  final String number;

  SearchView({super.key, required this.number});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  SearchController searchController = SearchController();

  @override
  void initState() {
    super.initState();
    searchController.init();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: searchController.search(widget.number),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Consumer<SettingModel>(
            builder: (context, value, child) => Scaffold(
              appBar: CustomAppBar(
                isBack: true,
                isSurface: true,
                data: widget.number,
              ),
              body: ListView(
                children: List.generate(
                  snapshot.data!.length,
                  (index) => CustomHistory(
                    probability: 100 *
                        double.parse(snapshot.data![index]['probability']),
                    date: snapshot.data![index]['createdAt']
                        .toString()
                        .substring(0, 10),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: colorScheme.primary,
              size: 32,
            ),
          );
        }
      },
    );
  }
}
