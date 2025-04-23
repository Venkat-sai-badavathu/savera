import 'package:flutter/material.dart';
import '../utils/colors.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  TextSpan boldHeading(String text) {
    return TextSpan(
      text: '\n$text\n',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        height: 2,
      ),
    );
  }

  TextSpan normalText(String text) {
    return TextSpan(
      text: '$text\n',
      style: const TextStyle(fontSize: 16, height: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: AppColors.primary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                    'Terms of Use – Savera App\n\nEffective Date: 14-04-2025\n\n',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    'Welcome to Savera, a digital platform designed to promote accessibility, community empowerment, and streamlined access to essential information and services.\n\n'
                    'Please read these Terms of Use (“Terms”) carefully before using the Savera mobile application or website (collectively referred to as the "Platform"). By accessing or using the Platform, you agree to comply with and be legally bound by these Terms, whether or not you register as a user.\n\n'
                    'Savera reserves the right to update or change these Terms at any time. Continued use of the Platform after changes are posted constitutes acceptance of the updated Terms.\n',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              TextSpan(
                text: '\n1. User Responsibilities and Conduct\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'You agree to use the Platform lawfully and ethically. You shall not:\n'
                    '- Post, share or transmit any content that is unlawful, threatening, defamatory, or otherwise objectionable.\n'
                    '- Attempt to gain unauthorized access to any part of the Platform.\n'
                    '- Violate applicable local, national, or international laws or regulations.\n'
                    '- Interfere with or disrupt the security, integrity, or performance of the Platform or its services.\n',
              ),
              TextSpan(
                text: '\n2. Prohibited Content and Activities\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'The following content and activities are strictly prohibited:\n'
                    '- Offensive, obscene, or defamatory materials.\n'
                    '- Malware or any code designed to harm systems or data.\n'
                    '- Misrepresentation of identity or impersonation.\n'
                    '- Advertising, spam, or unauthorized commercial content.\n'
                    '- Any activity aimed at disrupting or harming the Platform or other users.\n',
              ),
              TextSpan(
                text: '\n3. Account Registration and Security\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'To access certain features, you may be required to register for an account by providing accurate and complete information. You agree not to:\n'
                    '- Share your login credentials with anyone else.\n'
                    '- Use another person\'s account.\n'
                    '- Misuse any user data or information obtained through the Platform.\n\n'
                    'You are responsible for maintaining the confidentiality and security of your account.\n',
              ),
              TextSpan(
                text: '\n4. Use of Content\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'All content made available through the Platform (text, graphics, media, etc.) is the property of Savera or its content partners and is protected by applicable intellectual property laws.\n\n'
                    'You may access and use the content solely for your personal, non-commercial use unless otherwise specified. Reproduction, distribution, or modification of any Platform content without written permission is prohibited.\n',
              ),
              TextSpan(
                text: '\n5. User-Generated Content\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'You retain ownership of any content you upload or submit, but you grant Savera a non-exclusive, worldwide, royalty-free license to use, host, store, reproduce, and display your content solely for the purposes of operating, promoting, and improving our services.\n\n'
                    'You represent that you have the legal right to submit such content and that it does not violate the rights of others.\n',
              ),
              TextSpan(
                text: '\n6. Third-Party Services\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'Savera may contain links to third-party websites or services. We are not responsible for the content, policies, or practices of any third-party services.\n\n'
                    'Engagement with third-party platforms is at your own discretion and risk.\n',
              ),
              TextSpan(
                text: '\n7. Disclaimer of Warranties\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'The Platform and its services are provided on an “as-is” and “as-available” basis without warranties of any kind. Savera does not guarantee:\n'
                    '- Uninterrupted access or availability.\n'
                    '- Accuracy or completeness of any content.\n'
                    '- Freedom from viruses or harmful components.\n\n'
                    'Use of the Platform is at your own risk.\n',
              ),
              TextSpan(
                text: '\n8. Limitation of Liability\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'To the maximum extent permitted by law, Savera will not be liable for any indirect, incidental, consequential, or punitive damages arising from your use or inability to use the Platform.\n',
              ),
              TextSpan(
                text: '\n9. Termination of Access\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'Savera reserves the right to suspend or terminate your access at any time, without notice, for conduct that violates these Terms or is otherwise harmful to the Platform or other users.\n',
              ),
              TextSpan(
                text: '\n10. Governing Law\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'These Terms are governed by and construed in accordance with the laws of [Insert Jurisdiction]. All disputes arising from these Terms or your use of the Platform shall be subject to the exclusive jurisdiction of the courts in [Insert Jurisdiction].\n',
              ),
              TextSpan(
                text: '\n11. Contact Us\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              TextSpan(
                text:
                    'For any questions or concerns regarding these Terms, please contact us at:\n'
                    'Email: saverasupport@gmail.com\n'
                    'insta:mr_p_h_a_n_i_\n',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
