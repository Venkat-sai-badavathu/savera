import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:another_telephony/telephony.dart';
import '../routes.dart';
import 'package:geolocator/geolocator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _sosAnimationController;
  late Animation<double> _sosAnimation;
  int _currentIndex = 0;
  bool _isSendingSOS = false;
  int _countdown = 3;
  bool _smsPermissionGranted = false;
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    _sosAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _sosAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _sosAnimationController, curve: Curves.easeInOut),
    );

    _checkSmsPermission(); // Placeholder for future SMS permission logic
  }

  Future<void> _checkSmsPermission() async {
    setState(() => _smsPermissionGranted = true);
  }

  Future<void> _sendEmergencySMS() async {
    setState(() => _isSendingSOS = true);

    final bool permissionsGranted =
        await telephony.requestSmsPermissions ?? false;

    if (!permissionsGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SMS permission denied. Cannot send alert.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isSendingSOS = false);
      return;
    }

    const List<String> phoneNumbers = [
      '7075745294',
      '7093055425',
      '9642538555',
      '9959552795',
    ];
    String message = 'EMERGENCY! I need immediate help!';

    try {
      bool locationPermission = await _requestLocationPermission();
      if (locationPermission) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        message +=
            '\nLocation: https://maps.google.com/?q=${position.latitude},${position.longitude}';
      } else {
        message += '\n(Location permission denied)';
      }

      // Send SMS to all numbers
      for (final number in phoneNumbers) {
        await telephony.sendSms(to: number, message: message);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Emergency SMS sent with location'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send SMS: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSendingSOS = false);
    }
  }

  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  void _showSOSConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF75590).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    Remix.alarm_warning_line,
                    size: 40,
                    color: Color(0xFFF75590),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'SOS Alert',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Emergency alert will be sent in 3 seconds',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _startSOSCountdown();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF75590),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Confirm',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void _startSOSCountdown() {
    _countdown = 3;
    bool cancelled = false;
    Timer? timer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              if (cancelled) {
                t.cancel();
                return;
              }

              if (_countdown > 1) {
                setStateDialog(() {
                  _countdown--;
                });
              } else {
                t.cancel();
                Navigator.pop(context); // Close dialog
                _sendEmergencySMS(); // Trigger SMS
              }
            });

            return AlertDialog(
              backgroundColor: const Color(0xFFF75590),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Emergency Alert',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 4),
                      borderRadius: BorderRadius.circular(48),
                    ),
                    child: Center(
                      child: Text(
                        _countdown.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sending alert in $_countdown seconds',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () {
                      cancelled = true;
                      timer?.cancel();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFF75590),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToFeature(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.emergencyContacts);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.locationSharing);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.safetyAssistant);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.momentCapture);
        break;
    }
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        break; // Already on dashboard
      case 1:
        Navigator.pushNamed(context, AppRoutes.map);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Savera',
              style: GoogleFonts.pacifico(
                fontSize: 20,
                color: const Color(0xFFF75590),
              ),
            ),
            Text(
              'Women Safety',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: const Icon(Remix.user_line),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
            ),
          ],
        ),
        elevation: 1,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                // SOS Button
                Column(
                  children: [
                    ScaleTransition(
                      scale: _sosAnimation,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF75590),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF75590).withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(80),
                            onTap: _isSendingSOS ? null : _showSOSConfirmation,
                            child: Center(
                              child:
                                  _isSendingSOS
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text(
                                        'SOS',
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Emergency SOS',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Press for immediate help',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Feature Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildFeatureCard(
                      icon: Remix.phone_line,
                      title: 'Contacts',
                      subtitle: 'Quick help',
                      color: const Color(0xFFF75590),
                      onTap: () => _navigateToFeature(0),
                    ),
                    _buildFeatureCard(
                      icon: Remix.map_pin_line,
                      title: 'Location',
                      subtitle: 'Share location',
                      color: Colors.blue,
                      onTap: () => _navigateToFeature(1),
                    ),
                    _buildFeatureCard(
                      icon: Remix.message_3_line,
                      title: 'ChatBot',
                      subtitle: 'Safety assistant',
                      color: Colors.purple,
                      onTap: () => _navigateToFeature(2),
                    ),
                    _buildFeatureCard(
                      icon: Remix.camera_line,
                      title: 'Capture',
                      subtitle: 'Record evidence',
                      color: Colors.green,
                      onTap: () => _navigateToFeature(3),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isSendingSOS)
            const ModalBarrier(color: Colors.black54, dismissible: false),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFF75590),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Remix.home_5_line), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Remix.map_2_line), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Remix.user_line),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Remix.settings_3_line),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
