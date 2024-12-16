import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'diary_form.dart'; // 일기 수정 화면

class DiaryListScreen extends StatelessWidget {
  final int userId;

  const DiaryListScreen({Key? key, required this.userId}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchDiaryEntries() async {
    final db = await DBHelper.instance.database;
    return db.query(
      'diary_entries',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // 일기 삭제 메서드
  Future<void> _deleteDiary(int diaryId, BuildContext context) async {
    final db = await DBHelper.instance.database;

    // 삭제 확인 팝업
    bool confirmDelete = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('일기 삭제'),
              content: Text('정말로 이 일기를 삭제하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('삭제'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmDelete) {
      await db.delete(
        'diary_entries',
        where: 'id = ?',
        whereArgs: [diaryId],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일기가 삭제되었습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내가 쓴 일기'),
        backgroundColor: Colors.brown[700],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // 일기 목록 로드
        future: _fetchDiaryEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러가 발생했습니다: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('일기가 없습니다.'));
          }

          final entries = snapshot.data!;
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                leading: Icon(
                  entry['emotion'] == '행복'
                      ? Icons.sentiment_satisfied
                      : Icons.sentiment_dissatisfied,
                  color: entry['emotion'] == '행복' ? Colors.yellow : Colors.blue,
                ),
                title: Text(entry['content'] ?? '내용 없음'),
                subtitle: Text(entry['date'] ?? '날짜 없음'),
                onTap: () {
                  // 클릭된 일기를 수정할 수 있도록 DiaryForm으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiaryForm(
                        userId: userId,
                        diaryId: entry['id'], // 일기 ID 전달
                        existingContent: entry['content'], // 기존 일기 내용
                        existingEmotion: entry['emotion'], // 기존 감정
                        existingDate: DateTime.parse(entry['date']), // 기존 날짜
                      ),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteDiary(entry['id'], context),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
