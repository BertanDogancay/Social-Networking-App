import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/utils/colors.dart';
import 'package:private_chat_app/common/widgets/error.dart';
import 'package:private_chat_app/common/widgets/loader.dart';
import 'package:private_chat_app/features/auth/controller/auth_controller.dart';
import 'package:private_chat_app/features/landing/screens/landing_screen.dart';
import 'package:private_chat_app/firebase_options.dart';
import 'package:private_chat_app/common/utils/router.dart';
import 'package:private_chat_app/mobile_layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Whatsapp UI',
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: backgroundColor,
            appBarTheme: const AppBarTheme(color: appBarColor)),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const LandingScreen();
              //return const MobileLayoutScreen();
            },
            error: (err, trace) {
              print(err.toString());
              print(trace.toString());
              return ErrorScreen(error: err.toString());
            },
            loading: () => const Loader()));
  }
}
