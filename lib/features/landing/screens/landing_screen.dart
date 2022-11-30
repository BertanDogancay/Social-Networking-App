import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import '../../../common/utils/colors.dart';
import '../../../common/widgets/custom_button.dart';
import '../../auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 250.0,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold
                ), 
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TyperAnimatedText('WELCOME', 
                    textAlign: TextAlign.center, 
                    speed: const Duration(milliseconds: 300)),
                    TyperAnimatedText('BONJOUR', 
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 300)),
                    TyperAnimatedText('HOLA', 
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 300)),
                    TyperAnimatedText('MERHABA', 
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 300))
                  ]
                )
              ),
            ),
            // const Text('WELCOME',
            //     style: TextStyle(fontSize: 33, fontWeight: FontWeight.w600), 
            //     textAlign: TextAlign.center,),
            SizedBox(height: size.height / 10),
            Image.asset(
              'assets/cube.gif',
              height: 340,
              width: 340,
            ),
            SizedBox(height: size.height / 8),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                style: TextStyle(
                  color: greyColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: size.width * 0.75,
              child: CustomButton(
                  text: 'AGREE AND CONTINUE',
                  onPressed: () => navigateToLoginScreen(context)),
            ),
          ],
        ),
      ),
    );
  }
}