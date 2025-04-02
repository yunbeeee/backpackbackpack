import 'package:flutter/material.dart';
import 'package:backpack_front/widgets/signup_textfield.dart';
import 'package:backpack_front/widgets/signup_button.dart';
import 'signup_user_pw.dart';

class SignupUserId extends StatefulWidget {
  const SignupUserId({Key? key}) : super(key: key);

  @override
  _SignupUserIdState createState() => _SignupUserIdState();
}

class _SignupUserIdState extends State<SignupUserId> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isUsernameFilled = false; // Tracks if the username field is filled

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_checkUsernameInput);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  // Checks if the username field is filled
  void _checkUsernameInput() {
    setState(() {
      _isUsernameFilled = _usernameController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
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
              '거의 다 왔어요!\n이제 아이디를 정해주세요.',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '40자 이내의 영문 아이디를 만들어 주세요.\n대소문자 구분은 되지 않아요.',
              style: TextStyle(color: Color(0xFF9A9A9A), fontSize: 13),
            ),
            const SizedBox(height: 40),

            // Username input field using SignupTextfield widget
            SignupTextfield(
              labelText: '아이디',
              controller: _usernameController,
              onChanged: (_) => _checkUsernameInput(),
            ),

            const Spacer(),

            // "Next" button, shown only if the username is filled
            if (_isUsernameFilled)
              SignupButton(
                imagePath: '', // No icon for "Next" button
                text: '다음', // Button text
                color: const Color(0xFF121212), // Button background color
                textColor: Colors.white, // Button text color
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupUserPw()),
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
