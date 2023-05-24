import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/util/build.dart';
import 'package:the_voice/provider/setting_provider.dart';
import 'package:the_voice/view/call_view.dart';
import 'package:the_voice/view/home_view.dart';
import 'package:the_voice/view/message_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    SettingProvider sm = context.watch<SettingProvider>();

    String getTitle() {
      switch (_selectedIndex) {
        case 0:
          return sm.language == Language.english ? 'Call' : '전화';
        case 1:
          return '';
        case 2:
          return sm.language == Language.english ? 'Message' : '메시지';
        default:
          return '';
      }
    }

    PreferredSizeWidget buildAppBar() {
      return BuildAppBar(pushed: false, title: getTitle());
    }

    Widget buildBody() {
      switch (_selectedIndex) {
        case 0:
          return const CallView();
        case 1:
          return const HomeView();
        case 2:
          return const MessageView();
        default:
          return const HomeView();
      }
    }

    NavigationBar buildBottomNavigationBar() {
      return NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(
              _selectedIndex == 0 ? Icons.call : Icons.call_outlined,
            ),
            label: sm.language == Language.english ? 'Call' : '전화',
          ),
          NavigationDestination(
            icon: Icon(
              _selectedIndex == 1 ? Icons.home : Icons.home_outlined,
            ),
            label: sm.language == Language.english ? 'Home' : '홈',
          ),
          NavigationDestination(
            icon: Icon(
              _selectedIndex == 2 ? Icons.message : Icons.message_outlined,
            ),
            label: sm.language == Language.english ? 'Message' : '메시지',
          ),
        ],
        onDestinationSelected: (value) => setState(
          () => _selectedIndex = value,
        ),
      );
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
