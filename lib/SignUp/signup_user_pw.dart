import 'package:flutter/material.dart';
import 'package:backpack_front/widgets/signup_textfield.dart';
import 'package:backpack_front/widgets/signup_button.dart';
import 'signup_agree.dart';

class SignupUserPw extends StatefulWidget {
  const SignupUserPw({Key? key}) : super(key: key);

  @override
  _SignupUserPwState createState() => _SignupUserPwState();
}

class _SignupUserPwState extends State<SignupUserPw> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordValid = false;
  bool _isPasswordLengthValid = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordsMatch);
    _confirmPasswordController.addListener(_checkPasswordsMatch);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordsMatch() {
    setState(() {
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      _isPasswordLengthValid = password.length >= 10;
      _isPasswordValid = _isPasswordLengthValid && password == confirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/back_button.png',
            width: 12,
            height: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('회원가입', style: TextStyle(fontSize: 20, color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              '책가방 로그인에 사용할\n비밀번호를 정해주세요.',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '10자 이상의 특수문자를 포함한 비밀번호를 설정해주세요.',
              style: TextStyle(color: Color(0xFF9A9A9A), fontSize: 13),
            ),
            const SizedBox(height: 40),

            // Password input field
            SignupTextfield(
              labelText: '비밀번호',
              controller: _passwordController,
              onChanged: (_) => _checkPasswordsMatch(),
              inputType: TextInputType.visiblePassword,
              obscureText: true,
            ),

            if (!_isPasswordLengthValid)
              const Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  '10자 이상 입력해주세요',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 20),

            // Confirm password field with check icon
            Stack(
              children: [
                SignupTextfield(
                  labelText: '비밀번호 확인',
                  controller: _confirmPasswordController,
                  onChanged: (_) => _checkPasswordsMatch(),
                  inputType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                if (_isPasswordValid)
                  Positioned(
                    right: 0,
                    bottom: 10,
                    child: Image.asset(
                      'assets/SignUp_image/signup_check_grey.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
              ],
            ),

            const Spacer(),

            // Signup button
            if (_isPasswordValid)
              SignupButton(
                imagePath: '',
                text: '회원가입',
                color: const Color(0xFF121212),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupAgree()),
                  );
                },
                width: double.infinity,
                height: 50,
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
