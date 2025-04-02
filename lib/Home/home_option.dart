import 'package:flutter/material.dart';
import 'Memo/memo_class.dart'; // Memo 클래스 import

class HomeOption extends StatelessWidget {
  final List<Memo> memos; // Memo 리스트를 받는 필드

  HomeOption({required this.memos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '메모 목록',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: memos.isEmpty
          ? const Center(
        child: Text(
          '저장된 메모가 없습니다.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: memos.length,
        itemBuilder: (context, index) {
          final memo = memos[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                memo.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                memo.content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}