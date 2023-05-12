import 'package:flutter/material.dart';
import 'package:the_voice/controller/call_controller.dart';
import 'package:the_voice/model/build_model.dart';

class CallView extends StatefulWidget {
  const CallView({super.key});

  @override
  State<CallView> createState() => _CallViewState();
}

class _CallViewState extends State<CallView> {
  @override
  Widget build(BuildContext context) {
    String currHeader = '';
    String nextHeader = '';

    return FutureBuilder(
      future: CallController.fetchCalls(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: List<Widget>.generate(
              snapshot.data!.length,
              (index) {
                int minute = snapshot.data![index].duration! ~/ 60;
                int second = snapshot.data![index].duration! % 60;

                nextHeader = DateTime.fromMillisecondsSinceEpoch(
                  snapshot.data![index].timestamp!,
                ).toIso8601String().substring(0, 10);

                CustomCallListTile customCallListTile = CustomCallListTile(
                  leading: const CircleAvatar(radius: 32),
                  isHeader: currHeader != nextHeader,
                  header: nextHeader,
                  title: snapshot.data![index].number!,
                  subtitle: snapshot.data![index].callType
                      .toString()
                      .substring(9)
                      .toLowerCase(),
                  trailing:
                      '${minute < 10 ? '0$minute' : minute}:${second < 10 ? '0$second' : second}',
                  datetime: DateTime.fromMillisecondsSinceEpoch(
                    snapshot.data![index].timestamp!,
                  ).toIso8601String(),
                );

                currHeader = nextHeader;

                return customCallListTile;
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
