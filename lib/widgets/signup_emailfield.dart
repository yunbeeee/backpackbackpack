import 'package:flutter/material.dart';
import 'signup_textfield.dart';

class SignupEmailfield extends StatelessWidget {
  final TextEditingController localController;
  final TextEditingController domainController;
  final String selectedDomain;
  final List<String> emailDomains;
  final Function(String) onChanged;
  final Function(String?) onDomainChanged;

  const SignupEmailfield({
    Key? key,
    required this.localController,
    required this.domainController,
    required this.selectedDomain,
    required this.emailDomains,
    required this.onChanged,
    required this.onDomainChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // TextField for the local part of the email (before @)
        Expanded(
          child: SignupTextfield(
            labelText: '이메일',
            controller: localController,
            inputType: TextInputType.emailAddress,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 12.0),
        const Padding(
          padding: EdgeInsets.only(bottom: 7.0), // Position of @ symbol
          child: Text(
            '@',
            style: TextStyle(color: Color(0xFFA17956), fontSize: 16),
          ),
        ),
        const SizedBox(width: 12.0),

        // TextField for the domain part of the email (after @)
        Expanded(
          child: TextField(
            controller: domainController,
            readOnly: selectedDomain != '직접 입력',
            style: const TextStyle(color: Color(0xFFA17956), fontSize: 16),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 10),
            ),
            onChanged: (value) => onChanged(value),
          ),
        ),
        const SizedBox(width: 8.0),

        // Dropdown for selecting email domain
        Align(
          alignment: Alignment.bottomCenter, // Aligns dropdown to bottom for consistent layout
          child: Transform.translate(
            offset: const Offset(0, 5.0), // Slightly lowers dropdown to align with underline
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedDomain, // Currently selected domain
                items: emailDomains.map((String domain) {
                  // Maps each domain to a dropdown item
                  return DropdownMenuItem<String>(
                    value: domain,
                    child: Text(domain, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
                onChanged: onDomainChanged, // Calls onDomainChanged callback when selection changes
                iconSize: 24, // Size of dropdown icon
                style: const TextStyle(
                  color: Color(0XFFA17956),
                  fontSize: 16,
                ), // Text style for dropdown items
                dropdownColor: Colors.white, // Background color of dropdown menu
              ),
            ),
          ),
        ),
      ],
    );
  }
}