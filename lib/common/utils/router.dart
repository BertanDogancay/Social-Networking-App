import 'dart:io';
import 'package:flutter/material.dart';
import 'package:private_chat_app/common/widgets/error.dart';
import 'package:private_chat_app/features/auth/screens/login_screen.dart';
import 'package:private_chat_app/features/auth/screens/otp_screen.dart';
import 'package:private_chat_app/features/auth/screens/user_information_screen.dart';
import 'package:private_chat_app/features/group/screens/create_group_screen.dart';
import 'package:private_chat_app/features/select_contacts/screens/select_contact_screen.dart';
import 'package:private_chat_app/features/chat/screens/mobile_chat_screen.dart';
import 'package:private_chat_app/features/settings/screens/settings_screen.dart';
import 'package:private_chat_app/features/stories/screens/confirm_story_screen.dart';
import 'package:private_chat_app/features/stories/screens/stories_screen.dart';
import 'package:private_chat_app/features/stories/screens/story_screen.dart';
import 'package:private_chat_app/models/story_model.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: verificationId,
              ));
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const UserInformationScreen());
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final profilePic = arguments['profilePic'];
      final isGroupChat = arguments['isGroupChat'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
                profilePic: profilePic,
                isGroupChat: isGroupChat,
              ));
    case ConfirmStoryScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
          builder: (context) => ConfirmStoryScreen(
                file: file,
              ));
    case StoryScreen.routeName:
      final story = settings.arguments as StoryModel;
      return MaterialPageRoute(builder: (context) => StoryScreen(story: story));
    case StoriesScreen.routeName:
      return MaterialPageRoute(builder: (context) => const StoriesScreen());
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(builder: (context) => const CreateGroupScreen());
    case SettingsScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SettingsScreen());
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
              body: ErrorScreen(error: 'This page does not exist')));
  }
}
