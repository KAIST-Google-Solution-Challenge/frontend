import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/util/build.dart';
import 'package:the_voice/util/chart.dart';
import 'package:the_voice/provider/setting_provider.dart';
import 'package:the_voice/controller/search_service.dart';

class SearchView extends StatefulWidget {
  final String text;
  const SearchView({super.key, required this.text});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  SearchService searchService = SearchService();

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    Widget buildBody() {
      return FutureBuilder(
        future: searchService.search(widget.text),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'NO DATA',
                  style: tt.headlineLarge?.copyWith(color: cs.onSurface),
                ),
              );
            } else {
              return Consumer<SettingProvider>(
                builder: (_, value, __) => ListView(
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => BuildHistory(
                      probability: snapshot.data![index]['probability'],
                      date: snapshot.data![index]['timestamp'],
                    ),
                  ),
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }

    return Scaffold(
      appBar: BuildAppBar(pushed: true, title: widget.text),
      body: buildBody(),
    );
  }
}

class BuildHistory extends StatelessWidget {
  final double probability;
  final String date;

  const BuildHistory({
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
