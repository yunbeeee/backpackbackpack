import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileSetting extends StatefulWidget {
  const UserProfileSetting({Key? key}) : super(key: key);

  @override
  _UserProfileSettingState createState() => _UserProfileSettingState();
}

class _UserProfileSettingState extends State<UserProfileSetting> {
  File? _selectedImage; // Holds the selected image
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        print("Image selected: ${pickedFile.path}");
        _selectedImage = File(pickedFile.path); // Assign the File to _selectedImage
      } else {
        print("No image selected.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background: Selected image, default image, or gray
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: _selectedImage == null
                  ? Colors.grey // Gray background if no image is selected
                  : null, // Null color when displaying an image
              image: _selectedImage != null
                  ? DecorationImage(
                image: FileImage(_selectedImage!), // Show selected image
                fit: BoxFit.cover,
              )
                  : null, // No image when gray background is shown
            ),
          ),
          // Semi-transparent overlay
          Container(
            height: 250,
            color: Colors.black.withOpacity(0.5),
          ),
          // Centered camera icon
          Positioned.fill(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Show the modal when the camera icon is tapped
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildBottomSheet(); // Build modal content with rounded corners
                    },
                  );
                },
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),
          // Cancel button
          Positioned(
            top: 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Handle cancel action
              },
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          // Apply button
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                // Handle apply action
              },
              child: const Text(
                '적용',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the bottom sheet for camera options
  Widget _buildBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, // Modal background color
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // Rounded corners
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 23), // Left padding for text
            title: const Text(
              '갤러리에서 선택',
              style: TextStyle(fontSize: 18), // Font size set to 18
            ),
            onTap: () async {
              await _pickImageFromGallery(); // Open gallery to pick an image
              Navigator.pop(context); // Close the modal
            },
          ),
          const Divider(
            indent: 20, // Add padding to the left
            endIndent: 20, // Add padding to the right
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 23), // Left padding for text
            title: const Text(
              '사진 촬영',
              style: TextStyle(fontSize: 18), // Font size set to 18
            ),
            onTap: () {
              // Handle camera capture (to be implemented)
              Navigator.pop(context);
            },
          ),
          const Divider(
            indent: 20, // Add padding to the left
            endIndent: 20, // Add padding to the right
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 23), // Left padding for text
            title: const Text(
              '기본 이미지로 변경',
              style: TextStyle(fontSize: 18), // Font size set to 18
            ),
            onTap: () {
              // Reset to gray background
              setState(() {
                _selectedImage = null; // Clear the selected image
              });
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 20), // Add bottom padding
        ],
      ),
    );
  }
}
