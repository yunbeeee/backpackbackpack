import 'package:flutter/material.dart';

class SignupButton extends StatelessWidget {
  final String imagePath;
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  // Constructor
  const SignupButton({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.color,
    required this.textColor,
    required this.onPressed,
    this.width, // Optional width parameter
    this.height, // Optional height parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed, // Function to execute when the button is pressed
      icon: imagePath.isNotEmpty
          ? Image.asset(imagePath, width: 24, height: 24) // Load the icon if `imagePath` is not empty
          : const SizedBox.shrink(), // Otherwise, use an empty widget (no icon)
      label: Text(
        text, // Display text on the button
        style: TextStyle(color: textColor, fontSize: 20,),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: color, // Set background color of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}