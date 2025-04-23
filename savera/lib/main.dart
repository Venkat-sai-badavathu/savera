import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:savera/screens/dashboard_screen.dart';
import 'package:savera/screens/emergency_contacts_screen.dart';
import 'package:savera/screens/location_sharing_screen.dart';
import 'package:savera/screens/login_screen.dart';
import 'package:savera/screens/map_screen.dart';
import 'package:savera/screens/moment_capture_screen.dart';
import 'package:savera/screens/notification_settings_screen.dart';
import 'package:savera/screens/privacy_policy_screen.dart';
import 'package:savera/screens/profile_screen.dart';
import 'package:savera/screens/register_screen.dart';
import 'package:savera/screens/safety_assistant_screen.dart';
import 'package:savera/screens/settings_screen.dart';
import 'package:savera/services/notification_service.dart';
import 'package:savera/utils/constants.dart';
import 'screens/terms_of_service_screen.dart';
import 'package:savera/screens/image_response_screen.dart';

import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.dashboard: (context) => const DashboardScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.emergencyContacts:
            (context) => const EmergencyContactsScreen(),
        AppRoutes.locationSharing: (context) => const LocationSharing(),
        AppRoutes.map: (context) => const MapScreen(),
        AppRoutes.settings: (context) => const SettingsScreen(),
        AppRoutes.privacyPolicy: (context) => const PrivacyPolicyScreen(),
        AppRoutes.termsOfService: (context) => const TermsOfServiceScreen(),
        AppRoutes.notificationSettings:
            (context) => const NotificationSettingsScreen(),
        AppRoutes.momentCapture: (context) => MomentCaptureScreen(),
        AppRoutes.safetyAssistant: (context) => SafetyAssistantScreen(),

        AppRoutes.imageResponse: (context) {
          final imagePath =
              ModalRoute.of(context)!.settings.arguments as String;
          return ImageResponseScreen(imagePath: imagePath);
        },
      },
    );
  }
}
