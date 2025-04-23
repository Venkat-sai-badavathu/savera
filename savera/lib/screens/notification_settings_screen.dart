import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/colors.dart';
import '../services/notification_service.dart'; // Add this import

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _emergencyAlerts = true;
  bool _safetyTips = true;
  bool _locationUpdates = false;
  bool _appUpdates = true;
  bool _promotional = false;
  late final NotificationService _notificationService; // Add service instance

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService(); // Initialize service
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Notification Preferences'),
            _buildNotificationSwitch(
              title: 'Emergency Alerts',
              subtitle: 'Critical safety alerts and SOS notifications',
              value: _emergencyAlerts,
              onChanged: (value) => setState(() => _emergencyAlerts = value),
            ),
            _buildNotificationSwitch(
              title: 'Safety Tips',
              subtitle: 'Weekly safety tips and recommendations',
              value: _safetyTips,
              onChanged: (value) => setState(() => _safetyTips = value),
            ),
            _buildNotificationSwitch(
              title: 'Location Updates',
              subtitle: 'Notifications when contacts check your location',
              value: _locationUpdates,
              onChanged: (value) => setState(() => _locationUpdates = value),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Other Notifications'),
            _buildNotificationSwitch(
              title: 'App Updates',
              subtitle: 'New features and important updates',
              value: _appUpdates,
              onChanged: (value) => setState(() => _appUpdates = value),
            ),
            _buildNotificationSwitch(
              title: 'Promotional',
              subtitle: 'Offers and promotions from Savera',
              value: _promotional,
              onChanged: (value) => setState(() => _promotional = value),
            ),

            const SizedBox(height: 32),
            _buildTestNotificationButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildNotificationSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  Widget _buildTestNotificationButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: _sendTestNotification,
        child: Text(
          'Send Test Notification',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Future<void> _sendTestNotification() async {
    final hasPermission = await _notificationService.requestPermissions();

    if (hasPermission) {
      await _notificationService.showTestNotification();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Test notification sent')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification permission denied')),
        );
      }
    }
  }
}
