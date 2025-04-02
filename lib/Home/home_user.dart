import 'package:flutter/material.dart';
import 'User/user_profile_setting.dart'; // Adjust the path based on your folder structure

class HomeUser extends StatelessWidget {
  const HomeUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 배경 이미지 영역
          Column(
            children: [
              Container(
                height: 200, // 배경 이미지 높이 조절
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background_image.png'), // 배경 이미지 경로
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 100, // 배경과 탭 사이의 공간 채우기
                color: Colors.white, // 배경 색상 설정
              ),
            ],
          ),

          // 스크롤 가능한 콘텐츠
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 프로필 정보 섹션
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 160), // 배경 이미지와의 간격
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('assets/profile_placeholder.png'),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'chaendaljenner',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '팔로워 10K   팔로잉 10',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '회사랑 바보 멍청이 뚱개 비비디바비디부',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      // 프로필 수정 버튼
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserProfileSetting(),
                            ),
                          );
                        },
                        child: const Text(
                          '프로필 수정',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                // 책 섹션
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text('+', style: TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          '읽고 있는 책',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 탭 섹션
                DefaultTabController(
                  length: 4,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: const TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          indicatorColor: Colors.black,
                          tabs: [
                            Tab(text: '서재'),
                            Tab(text: '게시글'),
                            Tab(text: '서평'),
                            Tab(text: '좋아하는 구절'),
                          ],
                        ),
                      ),
                      Container(
                        height: 400, // 탭 내용 높이
                        child: const TabBarView(
                          children: [
                            Center(child: Text('서재 내용')),
                            Center(child: Text('게시글 내용')),
                            Center(child: Text('서평 내용')),
                            Center(child: Text('좋아하는 구절 내용')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 고정된 뒤로 가기 및 설정 버튼
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: Image.asset(
                'assets/back_button_white.png', // 뒤로가기 버튼 이미지 경로
                width: 24,
                height: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Image.asset(
                'assets/setting_button.png', // 설정 버튼 이미지 경로
                width: 24,
                height: 24,
              ),
              onPressed: () {
                // 설정 버튼 동작 추가
              },
            ),
          ),
        ],
      ),
    );
  }
}
