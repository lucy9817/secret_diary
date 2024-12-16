import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/user.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _login() async {
    final db = await DBHelper.instance.database;

    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름과 전화번호를 입력하세요!')),
      );
      return;
    }

    final result = await db.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
    );

    User user;
    if (result.isEmpty) {
      int id = await db.insert('users', {'name': name, 'phone': phone});
      user = User(id: id, name: name, phone: phone);
    } else {
      user = User.fromMap(result.first);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            color: Colors.white.withOpacity(0.9),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text('로그인', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: '이름'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: '전화번호'),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('로그인'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
