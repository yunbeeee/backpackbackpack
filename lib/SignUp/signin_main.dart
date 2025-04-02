import 'package:flutter/material.dart';
import 'package:backpack_front/widgets/signup_button.dart';

class SigninMain extends StatefulWidget {
  const SigninMain({Key? key}) : super(key: key);

  @override
  State<SigninMain> createState() => _SigninMainState();
}

class _SigninMainState extends State<SigninMain> {
  bool _obscureText = true;
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _pwFocusNode = FocusNode();
  String? _idHint = '아이디';
  String? _pwHint = '비밀번호';

  @override
  void initState() {
    super.initState();
    _idFocusNode.addListener(() => setState(() {
      _idHint = _idFocusNode.hasFocus ? null : '아이디';
    }));
    _pwFocusNode.addListener(() => setState(() {
      _pwHint = _pwFocusNode.hasFocus ? null : '비밀번호';
    }));
  }

  @override
  void dispose() {
    _idFocusNode.dispose();
    _pwFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181818),
        elevation: 0,
        actions: [
          IconButton(
            iconSize: 20,
            padding: const EdgeInsets.only(right: 20.0, top: 20.0),
            icon: Image.asset(
              'assets/SignUp_image/signin_close.png',
              color: Colors.white,
              width: 20,
              height: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Stack(
          children: [
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: Image.asset('assets/backpack_logo.png', width: 180, height: 60),
            ),
            Positioned.fill(
              top: 300,
              child: Column(
                children: [
                  _buildTextField(
                    focusNode: _idFocusNode,
                    hintText: _idHint,
                  ),
                  const SizedBox(height: 13),
                  _buildTextField(
                    focusNode: _pwFocusNode,
                    hintText: _pwHint,
                    obscureText: _obscureText,
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        _obscureText
                            ? 'assets/SignUp_image/signin_closed_eyes.png'
                            : 'assets/SignUp_image/signin_open_eyes.png',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                  const SizedBox(height: 3),
                  _buildTextButtons(),
                  const SizedBox(height: 20),
                  SignupButton(
                    imagePath: '',
                    text: '로그인',
                    color: const Color(0xFFA17956),
                    textColor: Colors.white,
                    width: double.infinity,
                    height: 50,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required FocusNode focusNode, String? hintText, bool obscureText = false, Widget? suffixIcon}) {
    return TextField(
      focusNode: focusNode,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFD4D4D4)),
        filled: true,
        fillColor: Colors.grey[700],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(color: Color(0xFFD4D4D4)),
    );
  }

  Widget _buildTextButtons() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(onPressed: () {}, child: const Text('아이디 찾기', style: TextStyle(color: Color(0xFFD4D4D4)))),
          const Text('|', style: TextStyle(color: Color(0xFFD4D4D4))),
          TextButton(onPressed: () {}, child: const Text('비밀번호 재설정', style: TextStyle(color: Color(0xFFD4D4D4)))),
        ],
      ),
    );
  }
}