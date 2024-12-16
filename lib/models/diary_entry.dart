class DiaryEntry {
  final int id;
  final int userId;
  final String emotion;
  final String content;
  final String date;
  final String? imagePath; // 이미지 경로는 선택적 필드로 설정

  DiaryEntry({
    required this.id,
    required this.userId,
    required this.emotion,
    required this.content,
    required this.date,
    this.imagePath, // 선택적 필드
  });

  // SQLite 데이터 매핑을 위한 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'emotion': emotion,
      'content': content,
      'date': date,
      'imagePath': imagePath, // 이미지 경로 추가
    };
  }

  // Map을 DiaryEntry 객체로 변환
  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      userId: map['userId'],
      emotion: map['emotion'],
      content: map['content'],
      date: map['date'],
      imagePath: map['imagePath'], // 이미지 경로 처리
    );
  }
}
