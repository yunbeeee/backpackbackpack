import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:backpack_front/utils/phone_formatter.dart';
import 'signup_textfield.dart';

class PhoneFieldWithButton extends StatelessWidget {
  final TextEditingController controller;
  final bool isPhoneComplete;
  final VoidCallback onSendCode;

  const PhoneFieldWithButton({
    Key? key,
    required this.controller,
    required this.isPhoneComplete,
    required this.onSendCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SignupTextfield(
          labelText: '휴대폰 번호',
          controller: controller,
          inputType: TextInputType.phone,
          onChanged: (_) {},
          inputFormatters: [
            PhoneNumberFormatter(), // Apply phone number formatter
            LengthLimitingTextInputFormatter(13), // Limit length to typical phone number length
          ],
        ),
        if (isPhoneComplete)
          Positioned(
            right: 0,
            bottom: 8,
            child: ElevatedButton(
              onPressed: onSendCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFACACAC),
                minimumSize: const Size(80, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('인증번호 발송', style: TextStyle(color: Colors.white)),
            ),
          ),
      ],
    );
  }
}