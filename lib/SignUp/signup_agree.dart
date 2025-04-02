import 'package:flutter/material.dart';
import 'package:backpack_front/widgets/signup_button.dart';
import 'package:backpack_front/Home/home_main.dart';

class SignupAgree extends StatefulWidget {
  const SignupAgree({Key? key}) : super(key: key);

  @override
  _SignupAgreeState createState() => _SignupAgreeState();
}

class _SignupAgreeState extends State<SignupAgree> {
  bool _isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align logo to the left
          children: [
            const SizedBox(height: 100),

            // Logo aligned to the left
            Image.asset(
              'assets/backpack_logo.png',
              width: 180,
              height: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),

            // Welcome message centered below the logo
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '회원이 되신 것을\n환영합니다!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Spacer(),

            // Agreement checkbox
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() => _isTermsAccepted = !_isTermsAccepted);
                  },
                  child: Image.asset(
                    _isTermsAccepted
                        ? 'assets/SignUp_image/signup_check_brown.png'
                        : 'assets/SignUp_image/signup_check_grey.png',
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    '약관 전체 동의(선택 동의 포함)',
                    style: TextStyle(color: Color(0xFFD4D4D4)),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white54, thickness: 0.5),

            const Spacer(),

            // "Start Using" button
            SignupButton(
              imagePath: '', // No icon
              text: '책가방 사용하러 가기',
              color: _isTermsAccepted ? const Color(0xFFA17956) : const Color(0xFF9A9A9A),
              textColor: Colors.white,
              width: double.infinity,
              height: 50,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeMain()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
