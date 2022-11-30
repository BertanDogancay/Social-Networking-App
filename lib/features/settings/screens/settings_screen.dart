import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/utils/colors.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/settings-screen';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool isUsernameEnabled = false;
  final usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController.text = "abcd";
  }

  void setUsernameStatus() {
    setState(() {
      isUsernameEnabled = !isUsernameEnabled;
    });
  }
  
  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            AnimatedTextKit(
              totalRepeatCount: 1,
              animatedTexts: [
                TypewriterAnimatedText(
                  'Username',
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal
                  ),
                  speed: const Duration(milliseconds: 100)
                )
              ],
            ),
            SizedBox(
              child: TextField(
                controller: usernameController,
                readOnly: !isUsernameEnabled,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: Colors.white60,
                      width: 1
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)
                    ),
                    borderSide: BorderSide(
                      color: isUsernameEnabled ? Colors.yellow
                      : Colors.white60,
                      width: 1
                    )
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Container(
                width: 400,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  border: Border.all(color: Colors.white60)
                ),
                child: isUsernameEnabled ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                    child: Text('Cancel',
                    style: TextStyle(color: mainColor),
                    ),
                    onPressed: () => setUsernameStatus(),
                  ),
                  TextButton(
                    child: const Text('Submit',
                    style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {},
                  ),
                  ],
                ) : Center(
                  child: TextButton(
                    child: const Text('Change username',
                    style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () => setUsernameStatus(),
                  ),
                ) 
              ),
            )
          ],
        ),
      ),
    );
  }
}