import 'package:flutter/material.dart';
import 'package:backpack_front/widgets/signup_button.dart';
import 'package:backpack_front/widgets/signup_textfield.dart';
import 'package:backpack_front/widgets/signup_phone_certified.dart';
import 'package:backpack_front/widgets/signup_emailfield.dart';
import 'signup_user_id.dart';

class SignupUserProfile extends StatefulWidget {
  const SignupUserProfile({Key? key}) : super(key: key);

  @override
  _SignupUserProfileState createState() => _SignupUserProfileState();
}

class _SignupUserProfileState extends State<SignupUserProfile> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _verificationController = TextEditingController();
  final _emailLocalController = TextEditingController();
  final _domainController = TextEditingController();

  String _selectedDomain = '직접 입력';
  bool _isPhoneComplete = false;
  bool _isVerificationSent = false;
  bool _isFormComplete = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkFormCompletion);
    _phoneController.addListener(_checkPhoneCompletion);
    _verificationController.addListener(_checkFormCompletion);
    _emailLocalController.addListener(_checkFormCompletion);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _verificationController.dispose();
    _emailLocalController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  void _checkFormCompletion() {
    setState(() {
      _isFormComplete = _nameController.text.isNotEmpty &&
          _isPhoneComplete &&
          _verificationController.text.isNotEmpty &&
          _emailLocalController.text.isNotEmpty &&
          (_selectedDomain != '직접 입력' || _domainController.text.isNotEmpty);
    });
  }

  void _checkPhoneCompletion() {
    setState(() {
      _isPhoneComplete = _phoneController.text.replaceAll('-', '').length == 11;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: IconButton(
            icon: Image.asset('assets/back_button.png', width: 12, height: 22),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text('회원가입', style: TextStyle(color: Colors.black, fontSize: 20)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text('반가워요! 회원 가입에 필요한\n유저 정보를 입력해주세요.', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 80),
            SignupTextfield(labelText: '이름', controller: _nameController, onChanged: (_) => _checkFormCompletion()),
            const SizedBox(height: 20),
            PhoneFieldWithButton(
              controller: _phoneController,
              isPhoneComplete: _isPhoneComplete,
              onSendCode: () => setState(() => _isVerificationSent = true),
            ),
            if (_isVerificationSent) ...[
              const SizedBox(height: 20),
              SignupTextfield(labelText: '인증번호', controller: _verificationController, inputType: TextInputType.number, onChanged: (_) => _checkFormCompletion()),
            ],
            const SizedBox(height: 20),
            SignupEmailfield(
              localController: _emailLocalController,
              domainController: _domainController,
              selectedDomain: _selectedDomain,
              emailDomains: ['직접 입력', 'naver.com', 'gmail.com', 'hanmail.net', 'nate.com'],
              onChanged: (_) => _checkFormCompletion(),
              onDomainChanged: (String? newValue) {
                setState(() {
                  _selectedDomain = newValue!;
                  if (_selectedDomain != '직접 입력') {
                    _domainController.text = _selectedDomain;
                  } else {
                    _domainController.clear();
                  }
                  _checkFormCompletion();
                });
              },
            ),
            const Spacer(),
            if (_isFormComplete)
              SignupButton(
                imagePath: '',
                text: '다음',
                color: const Color(0xFF121212),
                textColor: Colors.white,
                width: double.infinity,
                height: 50,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupUserId())),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
