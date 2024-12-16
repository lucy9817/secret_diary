import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/db_helper.dart';

class DiaryForm extends StatefulWidget {
  final int userId;
  final int? diaryId;
  final String? existingContent;
  final String? existingEmotion;
  final DateTime? existingDate;

  const DiaryForm({
    Key? key,
    required this.userId,
    this.diaryId,
    this.existingContent,
    this.existingEmotion,
    this.existingDate,
  }) : super(key: key);

  @override
  _DiaryFormState createState() => _DiaryFormState();
}

class _DiaryFormState extends State<DiaryForm> {
  final TextEditingController _contentController = TextEditingController();
  String _selectedEmotion = '행복';
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  int _remainingCharacters = 500;

  @override
  void initState() {
    super.initState();
    // 기존 데이터로 초기화
    if (widget.existingContent != null) {
      _contentController.text = widget.existingContent!;
    }
    if (widget.existingEmotion != null) {
      _selectedEmotion = widget.existingEmotion!;
    }
    if (widget.existingDate != null) {
      _selectedDate = widget.existingDate!;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveDiary() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('일기 내용을 입력해주세요!')),
      );
      return;
    }

    final db = await DBHelper.instance.database;

    if (widget.diaryId != null) {
      // 수정
      await db.update(
        'diary_entries',
        {
          'content': _contentController.text.trim(),
          'emotion': _selectedEmotion,
          'date': _selectedDate.toIso8601String(),
          'imagePath': _selectedImage?.path,
        },
        where: 'id = ?',
        whereArgs: [widget.diaryId],
      );
    } else {
      // 새 일기 저장
      await db.insert('diary_entries', {
        'userId': widget.userId,
        'emotion': _selectedEmotion,
        'content': _contentController.text.trim(),
        'date': _selectedDate.toIso8601String(),
        'imagePath': _selectedImage?.path,
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('일기가 저장되었습니다!')),
    );
    Navigator.pop(context);
  }

  // 일기 삭제
  Future<void> _deleteDiary() async {
    final db = await DBHelper.instance.database;

    await db.delete(
      'diary_entries',
      where: 'id = ?',
      whereArgs: [widget.diaryId],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('일기가 삭제되었습니다.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('일기 쓰기'), backgroundColor: Colors.brown),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: _pickImage,
              child: _selectedImage == null
                  ? const Text('사진 추가')
                  : Image.file(_selectedImage!, height: 150),
            ),
            DropdownButtonFormField<String>(
              value: _selectedEmotion,
              items: ['행복', '슬픔', '화남', '평온']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() {
                _selectedEmotion = value!;
              }),
            ),
            Row(
              children: [
                Text(
                    "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}",
                    style: const TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: const Text('날짜 선택'),
                ),
              ],
            ),
            TextField(
              controller: _contentController,
              maxLength: 500,
              maxLines: 5,
              decoration: const InputDecoration(labelText: '일기 내용'),
            ),
            Text('남은 글자 수: $_remainingCharacters'),
            ElevatedButton(
              onPressed: _saveDiary,
              child: const Text('저장하기'),
            ),
            if (widget.diaryId != null)
              ElevatedButton(
                onPressed: _deleteDiary,
                child: const Text('삭제하기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
