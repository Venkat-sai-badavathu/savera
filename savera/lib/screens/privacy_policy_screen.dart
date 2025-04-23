import 'package:flutter/material.dart';
import '../utils/colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextSpan heading(String text) => TextSpan(
      text: '\n$text\n',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        height: 2,
      ),
    );

    TextSpan body(String text) => TextSpan(
      text: '$text\n\n',
      style: const TextStyle(fontSize: 16, height: 1.5),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'Privacy Policy for Savera\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  height: 2,
                ),
              ),
              TextSpan(
                text: 'Effective Date: 14-04-2025\n\n',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              // Section 1
              TextSpan(
                text:
                    'The Savera Mobile App is maintained and developed to support women\'s safety through location-based services and emergency contact features. We respect the privacy of all users and are committed to protecting any personal information you provide while using the app.\n\n',
              ),

              // Section 2
              TextSpan(
                text: 'Site & App Visit Data\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'When you use the Savera app, certain technical data is recorded for statistical and diagnostic purposes. This may include:\n'
                    '- Your device’s IP address\n'
                    '- The type and version of your browser or operating system\n'
                    '- Date and time of access\n'
                    '- Pages accessed and features used within the app\n'
                    '- Previous website or app from which you were referred\n\n'
                    'We do not use this data to personally identify users, unless legally required to do so (e.g., by law enforcement).\n\n',
              ),

              // Section 3
              TextSpan(
                text: 'Cookies and App Storage\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'A cookie is a piece of data that may be stored locally on your device. While Savera is a mobile app and not a traditional website, it may use local storage or app-based cookies for essential functions (such as remembering settings or login status).\n\n',
              ),

              // Section 4
              TextSpan(
                text: 'Email Management\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'If you choose to contact us via email, your email address will:\n'
                    '- Only be used for the purpose you provided it\n'
                    '- Not be shared with third parties\n'
                    '- Not be added to any mailing list without your consent\n\n',
              ),

              // Section 5
              TextSpan(
                text: 'Collection of Personal Information\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'Savera does not automatically collect personal information. However, the app may store details you provide voluntarily, such as:\n'
                    '- Your name\n'
                    '- Phone number\n'
                    '- State and city\n'
                    '- Emergency contact information\n\n'
                    'This information is stored only with your consent and is used to provide app features like emergency alerts and live location sharing.\n\n'
                    'If you are asked for additional personal data, you will be informed of the purpose. Your data may be retained for security, safety audits, abuse prevention, and legal compliance.\n\n',
              ),

              // Section 6
              TextSpan(
                text: 'Location Access\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'Savera accesses your real-time location (foreground and optionally background) for the following purposes:\n'
                    '- To detect your exact location in emergencies\n'
                    '- To notify and track with emergency contacts\n'
                    '- To center the map and location features around your real-time position\n\n'
                    'Location data is never shared with unauthorized third parties and is only used to enhance your safety.\n\n',
              ),

              // Section 7
              TextSpan(
                text: 'Account Deactivation and Data Retention\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'If you wish to deactivate your account:\n'
                    '- You can request account deletion through the app’s support section\n'
                    '- Deactivation is permanent and cannot be reversed\n'
                    '- Some non-personal data (e.g., usage logs) may be retained for compliance and legal purposes\n\n'
                    'Exceptions:\n'
                    '- Emergency event records and past logs may be retained for safety and law enforcement requests\n'
                    '- Aggregated or anonymized data may be retained for app improvement or research purposes\n\n',
              ),

              // Section 8
              TextSpan(
                text: 'Security of Your Personal Information\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'We use strict security measures to protect your data, including:\n'
                    '- Encrypted communication\n'
                    '- Secure cloud storage\n'
                    '- Access controls and security audits\n\n'
                    'Data is protected both in transit and at rest using industry-standard security protocols.\n\n',
              ),

              // Section 9
              TextSpan(
                text: 'Children’s Privacy\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'Savera is not intended for users under the age of 13. We do not knowingly collect personal information from children.\n\n',
              ),

              // Section 10
              TextSpan(
                text: 'Changes to the Privacy Policy\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'We may update this Privacy Policy periodically. Significant changes will be notified to users through the app.\n\n',
              ),

              // Section 11
              TextSpan(
                text: 'Contact Us\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 2,
                ),
              ),
              TextSpan(text: '📧 Email: support@saveraapp.com\n'),
            ],
          ),
        ),
      ),
    );
  }
}
