import 'package:flutter/material.dart';
import '../models/user.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 수정'),
        backgroundColor: const Color.fromARGB(255, 114, 78, 114),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이름: ${user.name}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              '전화번호: ${user.phone}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 프로필 수정 기능 추가 예정
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('프로필 수정 기능은 개발 중입니다.')),
                );
              },
              child: const Text('수정하기'),
            ),
          ],
        ),
      ),
    );
  }
}
