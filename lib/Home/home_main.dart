import 'package:flutter/material.dart';

import 'home_page.dart';
import 'home_option.dart';
import 'home_plus.dart'; // HomePlus 파일 import
import 'home_user.dart';
import 'home_chatbot.dart';

import 'Memo/memo_class.dart';


class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  int currentIndex = 0;

  final List<Memo> memos = [];

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(), // 홈 화면으로 사용할 첫 번째 페이지
      HomeOption(memos: memos),
      Container(), // plus 버튼은 직접 페이지 이동 처리
      HomeChatbot(),
      HomeUser(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF181818),
        unselectedItemColor: const Color(0xFF9A9A9A),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 2) {
            // plus 버튼 클릭 시 HomePlus로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePlus(memos: memos), // memos 전달
              ),
            ).then((_) {
              setState(() {}); // 돌아왔을 때 상태 갱신
            });
          } else {
            setState(() {
              currentIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage('assets/Home_image/bottom_home_icon.png'),
              size: 30,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage('assets/Home_image/bottom_option_icon.png'),
              size: 30,
            ),
            label: '옵션',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/Home_image/bottom_plus_icon.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            label: '추가',
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage('assets/Home_image/bottom_chatbot_icon.png'),
              size: 30,
            ),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage('assets/Home_image/bottom_user_icon.png'),
              size: 30,
            ),
            label: '유저',
          ),
        ],
      ),
    );
  }
}