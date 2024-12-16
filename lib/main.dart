import 'package:flutter/material.dart';
import 'package:secret_diary_stars/screens/diary_form.dart';
import 'package:secret_diary_stars/screens/diary_list_screen.dart';
import 'package:secret_diary_stars/screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart'; // HomeScreen 추가
import 'models/user.dart'; // User 모델 추가

void main() {
  runApp(const SecretDiaryApp());
}

class SecretDiaryApp extends StatelessWidget {
  const SecretDiaryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secret Diary Stars',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(), // 앱 시작 시 로그인 화면
      routes: {
        '/home': (context) => HomeScreen(
            user: User(
                id: 1, name: '사용자', phone: '010-1234-5678')), // 로그인 후 홈 화면으로 이동
        '/diary_form': (context) => DiaryForm(userId: 1), // 일기 작성 화면
        '/profile': (context) => ProfileScreen(
            user:
                User(id: 1, name: '사용자', phone: '010-1234-5678')), // 프로필 수정 화면
        '/diary_list': (context) => DiaryListScreen(userId: 1), // 일기 목록 조회 화면
      },
    );
  }
}
