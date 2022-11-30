class StorySeenModel {
  final String userId;
  bool isSeen;
  StorySeenModel({
    required this.userId,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'isSeen': isSeen,
    };
  }

  factory StorySeenModel.fromMap(Map<String, dynamic> map) {
    return StorySeenModel(
      userId: map['userId'] as String,
      isSeen: map['isSeen'] as bool,
    );
  }
}
