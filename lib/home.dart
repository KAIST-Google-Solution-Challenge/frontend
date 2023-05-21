import 'package:flutter/material.dart';
import 'package:the_voice/model/build_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/call_view.dart';
import 'package:the_voice/view/home_view.dart';
import 'package:the_voice/view/message_view.dart';

class Home extends StatefulWidget {
  final SettingModel sm;
  const Home({super.key, required this.sm});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(widget.sm),
      body: _buildBody(widget.sm),
      bottomNavigationBar: _buildBottomNavigationBar(widget.sm),
    );
  }

  PreferredSizeWidget _buildAppBar(SettingModel sm) {
    return BuildAppBar(pushed: false, title: _getTitle(sm));
  }

  String _getTitle(SettingModel sm) {
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

  Widget _buildBody(SettingModel sm) {
    switch (_selectedIndex) {
      case 0:
        return const CallView();
      case 1:
        return HomeView(sm: sm);
      case 2:
        return const MessageView();
      default:
        return HomeView(sm: sm);
    }
  }

  NavigationBar _buildBottomNavigationBar(SettingModel sm) {
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
}
