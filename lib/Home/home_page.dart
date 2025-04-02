import 'package:flutter/material.dart';
import 'HomePage/homepage_search.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181818),
        elevation: 0,
        centerTitle: false,
        title: Image.asset(
          'assets/backpack_logo.png',
          width: 90,
          fit: BoxFit.contain,
        ),
      ),
      body: const HomeContent(), // Home content
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F6F6),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'OOO님,',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                '오늘도 책가방과 함께\n새로운 페이지를 펼쳐 보아요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildSearchSection(context),
              const SizedBox(height: 20),
              _buildShelfSection(context),
              const SizedBox(height: 20),
              _buildStatisticSection(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // 책 등록 페이지로 이동
            },
            child: const Text(
              '책 등록하러 가기 >',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomepageSearch())
              );// 검색창 클릭 시 동작
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/Home_image/book_search.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '책 제목, 저자, 키워드 등을 입력하세요.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8C8C8C),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShelfSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          // 내 서재로 이동
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '내 서재 바로가기 >',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/Home_image/book_shelf.png',
              width: double.infinity,
              height: 180,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          // 통계 보기 이동
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '독서 통계 보기 >',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/Home_image/book_statistic.png',
              width: double.infinity,
              height: 180,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}