import 'package:flutter/material.dart';
import 'home_main.dart';
import 'Memo/memo_class.dart';

class HomePlus extends StatefulWidget {

  final List<Memo> memos;

  HomePlus({required this.memos});

  @override
  _HomePlusState createState() => _HomePlusState();
}

class _HomePlusState extends State<HomePlus> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool isButtonVisible = false;

  void _updateButtonVisibility() {
    setState(() {
      // 제목이나 내용에 입력이 있으면 버튼 보이기
      isButtonVisible = _titleController.text.isNotEmpty || _contentController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    // 텍스트 필드 입력값 변경 감지
    _titleController.addListener(_updateButtonVisibility);
    _contentController.addListener(_updateButtonVisibility);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveMemo() {
    final title = _titleController.text.trim(); // 제목 가져오기
    final content = _contentController.text.trim(); // 내용 가져오기

    if (title.isNotEmpty || content.isNotEmpty) {
      setState(() {
        // 새로운 Memo 객체를 리스트에 추가
        widget.memos.add(Memo(title: title, content: content));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset(
            'assets/back_button.png', // 이전 버튼 이미지
            width: 24,
            height: 24,
          ),
          onPressed: () {
            _saveMemo();
            Navigator.pop(context);
          } // 뒤로가기 동작
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/Home_image/memo_home.png', // 홈 버튼 이미지
              width: 24,
              height: 24,
            ),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            }
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // 메뉴 버튼 동작 추가
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8), // 드롭다운과 제목 간격 좁힘
                // 드롭다운 메뉴
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: '기타 메모',
                    isExpanded: false,
                    items: const [
                      DropdownMenuItem(
                        value: '기타 메모',
                        child: Text(
                          '기타 메모',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      DropdownMenuItem(
                        value: '다른 메모',
                        child: Text(
                          '다른 메모',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      // 드롭다운 값 변경 처리
                    },
                    // 커스텀 화살표 아이콘만 표시
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8), // 텍스트와 화살표 사이 거리
                        Image.asset(
                          'assets/Home_image/memo_dropdown.png', // 화살표 이미지 경로
                          width: 16,
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8), // 제목과 드롭다운 사이 간격 좁힘
                // 제목 입력 필드
                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '제목',
                    hintStyle: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFBDBDBD),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 0.5,
                ),
                const SizedBox(height: 8),
                // 메모 입력 필드
                TextField(
                  controller: _contentController,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '메모를 입력해주세요!',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFBDBDBD),
                    ),
                  ),
                  maxLines: null,
                ),
              ],
            ),
          ),
          // 우측 하단 버튼
          if (isButtonVisible)
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // 그림자 색상
                      blurRadius: 8, // 그림자 퍼짐 정도
                      offset: Offset(0, 4), // 그림자 위치
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Less rounded corners
                          ),
                          backgroundColor: Colors.white, // White background
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 280), // Reduce dialog width
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min, // Adjust size to fit content
                                children: [
                                  // Centered dialog text
                                  Text(
                                    '프로필에 게시하시겠습니까?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 20), // Space between text and buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center, // Align buttons to the center
                                    children: [
                                      // "취소" button
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context); // Close dialog
                                        },
                                        child: Text(
                                          '취소',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black, // Black text color
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 90), // Add space between "취소" and "게시"
                                      // "게시" button
                                      TextButton(
                                        onPressed: () {
                                          // Add action for "게시" button
                                          Navigator.pop(context); // Close dialog
                                        },
                                        child: Text(
                                          '게시',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF8B4513), // Brown text color
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Image.asset(
                    'assets/Home_image/memo_send.png', // 아이콘 이미지 경로
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
