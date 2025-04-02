import 'package:flutter/material.dart';

class HomepageSearch extends StatelessWidget {
  const HomepageSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset(
            'assets/back_button.png',
            width: 24,
            height: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '검색',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 0, child: Text('직접 등록하기')),
              PopupMenuItem(value: 1, child: Text('바코드로 검색하기')),
            ],
            onSelected: (value) {
              if (value == 0) {
                print("직접 등록하기 선택됨");
              } else if (value == 1) {
                print("바코드 검색 선택됨");
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 검색창
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                SizedBox(width: 8),
                Text('책 제목, 저자, 키워드 등을 입력하세요.',
                    style: TextStyle(color: Colors.grey)),
                Spacer(),
                Icon(Icons.search, color: Colors.grey),
              ],
            ),
          ),

          // 추천 문구
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: '어떤 책을 읽어볼지 고민될 땐, '),
                  TextSpan(
                    text: '책가방',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA17956),
                    ),
                  ),
                  TextSpan(text: ' 추천'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 배너 이미지
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/Home_image/book_advertise.png',
                width: 450,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Top 50 타이틀
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '전체 도서 Top 50',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('더보기', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '10월 24일 오후 7시 업데이트',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Color(0xFFD9D9D9), thickness: 1),
          ),

          // 책 리스트 (간단 반복 예시)
          ...List.generate(3, (index) => _BookItem(rank: index + 1)),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Color(0xFFD9D9D9), thickness: 1),
          ),

          const SizedBox(height: 10),

          // 장르별 랭킹 보기
          GestureDetector(
            onTap: () {
              print("장르별 랭킹 보기 클릭됨");
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '장르별 랭킹 보기',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

// 책 아이템 위젯
class _BookItem extends StatelessWidget {
  final int rank;

  const _BookItem({required this.rank});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 썸네일 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/Home_image/book_top50.png',
              width: 50,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),

          // 책 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$rank',
                      style: const TextStyle(
                        color: Color(0xFFA17956),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '소년이 온다',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '한강 (지은이) | 창비 | 2014년 5월',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Text('등록 수 20K', style: TextStyle(fontSize: 12, color: Color(0xFF46B1E1))),
                    SizedBox(width: 6),
                    Text('·', style: TextStyle(fontSize: 12, color: Color(0xFF46B1E1))),
                    SizedBox(width: 6),
                    Text('서평 수 300', style: TextStyle(fontSize: 12, color: Color(0xFF46B1E1))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}