import 'package:private_chat_app/models/story_seen_model.dart';

class StoryModel {
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final String storyId;
  final List<StorySeenModel> seen;
  final List<String> usersAccessed;
  StoryModel({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.photoUrl,
    required this.createdAt,
    required this.profilePic,
    required this.storyId,
    required this.seen,
    required this.usersAccessed,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'storyId': storyId,
      'seen': seen.map((x) => x.toMap()).toList(),
      'usersAccessed': usersAccessed,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
        uid: map['uid'] ?? '',
        username: map['username'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        photoUrl: List<String>.from(map['photoUrl']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        profilePic: map['profilePic'] ?? '',
        storyId: map['storyId'] ?? '',
        seen: List<StorySeenModel>.from((map['seen'] as List<dynamic>)
            .map<StorySeenModel>(
                (x) => StorySeenModel.fromMap(x as Map<String, dynamic>))),
        usersAccessed: List<String>.from(map['usersAccessed']));
  }
}
