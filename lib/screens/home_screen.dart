import 'package:flutter/material.dart';
import 'package:secret_diary_stars/screens/star_painter.dart';
import '../models/user.dart';
import '../models/star.dart';
import '../utils/star_utils.dart';
import 'diary_list_screen.dart'; // 내가 쓴 일기 조회 화면
import 'profile_screen.dart'; // 프로필 수정 화면

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Star? _selectedStar; // 클릭된 별
  String _emotion = ''; // 클릭된 별의 감정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.name}의 별자리'),
        backgroundColor: const Color.fromARGB(255, 111, 64, 142),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Center(
                child: Text(
                  '${widget.user.name}의 메뉴',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('프로필 수정'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: widget.user),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('내가 쓴 일기'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DiaryListScreen(userId: widget.user.id),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // 밤하늘 배경
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/night_sky.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<List<Star>>(
            future: generateStarsFromDiary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('오류가 발생했습니다: ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('작성된 일기가 없습니다.'));
              }

              final stars = snapshot.data!;
              return InteractiveViewer(
                panEnabled: true, // 드래그를 통해 이동 가능하게 설정
                boundaryMargin: const EdgeInsets.all(80), // 이동 가능한 범위 설정
                minScale: 0.1, // 최소 확대 비율
                maxScale: 2.0, // 최대 확대 비율
                child: CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: StarPainter(stars),
                ),
              );
            },
          ),
          if (_selectedStar != null)
            Positioned(
              bottom: 50,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white.withOpacity(0.7),
                child: Text(
                  '감정: $_emotion',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, '/diary_form').then((_) {
            generateStarsFromDiary();
          });
        },
      ),
    );
  }
}
