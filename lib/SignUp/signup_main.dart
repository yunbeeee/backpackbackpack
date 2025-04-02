import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'signin_main.dart';
import 'signup_user_profile.dart';
import 'package:backpack_front/widgets/signup_button.dart';

class SignupMain extends StatelessWidget {
  const SignupMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0), // **Changed: Added horizontal padding**
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // **Changed: Centered content vertically**
          children: [
            const Spacer(flex: 2), // **Changed: Top spacer with flex for alignment**
            Center(
              child: Image.asset(
                'assets/backpack_logo.png',
                width: 200, // **Changed: Adjusted logo width**
                height: 130, // **Changed: Adjusted logo height**
              ),
            ),
            const SizedBox(height: 30), // **Changed: Spacing below logo**
            const Spacer(),

            // Button: Kakao
            SignupButton(
              imagePath: 'assets/SignUp_image/signup_kakao_icon.png',
              text: '카카오로 시작하기',
              color: const Color(0xFFF9E000),
              textColor: const Color(0xFF3A1D1D),
              onPressed: () {},
            ),
            const SizedBox(height: 12),

            // Button: Naver
            SignupButton(
              imagePath: 'assets/SignUp_image/signup_naver_icon.png',
              text: '네이버로 시작하기',
              color: Colors.white,
              textColor: Colors.black,
              onPressed: () {},
            ),
            const SizedBox(height: 12),

            // Button: Apple
            SignupButton(
              imagePath: 'assets/SignUp_image/signup_apple_icon.png',
              text: 'Apple로 시작하기',
              color: Colors.black,
              textColor: Colors.white,
              onPressed: () {},
            ),
            const SizedBox(height: 12),

            // Button: Email
            SignupButton(
              imagePath: 'assets/SignUp_image/signup_email_icon.png',
              text: '이메일로 시작하기',
              color: const Color(0xFFA17956),
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupUserProfile()),
                );
              },
            ),
            const Spacer(), // **Changed: Added spacer for alignment**

            // Sign-in prompt
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: '이미 가입하셨나요? ',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                children: [
                  TextSpan(
                    text: '로그인하기',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SigninMain()),
                        );
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // **Changed: Bottom spacing**
          ],
        ),
      ),
    );
  }
}
