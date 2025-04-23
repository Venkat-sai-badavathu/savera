import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../routes.dart';
import '../utils/colors.dart';

class LocationSharing extends StatefulWidget {
  const LocationSharing({super.key});

  @override
  State<LocationSharing> createState() => _LocationSharingScreenState();
}

class _LocationSharingScreenState extends State<LocationSharing>
    with TickerProviderStateMixin {
  late AnimationController _sosAnimationController;
  late Animation<double> _sosAnimation;
  LatLng? _currentPosition;
  String _currentAddress = "123 Main Street, Downtown, New York, NY 10001";
  double _accuracy = 5.0;
  bool _isSharingLocation = false;
  bool _showShareModal = false;
  String _selectedShareTime = "1h";
  final Set<String> _selectedContacts = {"Emily Johnson", "Sarah Williams"};

  @override
  void initState() {
    super.initState();
    _initLocation();
    _setupSOSAnimation();
  }

  void _setupSOSAnimation() {
    _sosAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _sosAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _sosAnimationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initLocation() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _accuracy = position.accuracy;
      });
      // In a real app, you would geocode the coordinates to get an address
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  void _toggleShareModal() {
    setState(() {
      _showShareModal = !_showShareModal;
    });
  }

  void _startSharingLocation() {
    setState(() {
      _isSharingLocation = true;
      _showShareModal = false;
    });
    // In a real app, you would start sharing location with backend
  }

  void _stopSharingLocation() {
    setState(() {
      _isSharingLocation = false;
    });
    // In a real app, you would stop sharing location with backend
  }

  void _toggleContactSelection(String contact) {
    setState(() {
      if (_selectedContacts.contains(contact)) {
        _selectedContacts.remove(contact);
      } else {
        _selectedContacts.add(contact);
      }
    });
  }

  void _openDirections() async {
    if (_currentPosition == null) return;

    final url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=${_currentPosition!.latitude},${_currentPosition!.longitude}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not open maps")));
    }
  }

  void _markSafeLocation() {
    // In a real app, you would save this as a safe location
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Location marked as safe")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Location",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Remix.refresh_line),
            onPressed: _getCurrentLocation,
          ),
          IconButton(
            icon: const Icon(Remix.settings_4_line),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Map Container
                SizedBox(
                  height: 300,
                  child:
                      _currentPosition == null
                          ? _buildMapPlaceholder()
                          : GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _currentPosition!,
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId("currentLocation"),
                                position: _currentPosition!,
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueRose,
                                ),
                              ),
                            },
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                          ),
                ),

                // Action Buttons
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Remix.map_pin_line,
                        label: "Share",
                        onTap: _toggleShareModal,
                      ),
                      _buildActionButton(
                        icon: Remix.pin_distance_line,
                        label: "Directions",
                        onTap: _openDirections,
                      ),
                      _buildActionButton(
                        icon: Remix.map_pin_add_line,
                        label: "Mark Safe",
                        onTap: _markSafeLocation,
                      ),
                    ],
                  ),
                ),

                // Current Location Details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF5F5F5)),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Remix.map_pin_line,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Location",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currentAddress,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Nearby Safe Zones
                _buildSectionHeader(
                  title: "Nearby Safe Zones",
                  actionText: "View All",
                  onAction: () {
                    //  Navigator.pushNamed(context, AppRoutes.safeZones);
                  },
                ),
                _buildSafeZoneItem(
                  icon: Remix.police_car_line,
                  iconColor: Colors.blue,
                  bgColor: Colors.blue[100]!,
                  title: "Central Police Station",
                  subtitle: "0.8 miles away • Open 24/7",
                ),
                _buildSafeZoneItem(
                  icon: Remix.hospital_line,
                  iconColor: Colors.red,
                  bgColor: Colors.red[100]!,
                  title: "City General Hospital",
                  subtitle: "1.2 miles away • Open 24/7",
                ),
                _buildSafeZoneItem(
                  icon: Remix.home_heart_line,
                  iconColor: Colors.green,
                  bgColor: Colors.green[100]!,
                  title: "Women's Safety Shelter",
                  subtitle: "1.5 miles away • Open 24/7",
                ),

                // Contacts Sharing Location
                _buildSectionHeader(
                  title: "Contacts Sharing Location",
                  actionText: "Manage",
                  onAction: () {
                    Navigator.pushNamed(context, AppRoutes.emergencyContacts);
                  },
                ),
                _buildContactItem(
                  initials: "EJ",
                  name: "Phani",
                  status: "2.3 miles away • Updated 2 min ago",
                ),
                _buildContactItem(
                  initials: "SW",
                  name: "jhansi",
                  status: "5.1 miles away • Updated 15 min ago",
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Share Location Modal
          if (_showShareModal) _buildShareLocationModal(),

          // // SOS Button
          // Positioned(
          //   bottom: 80,
          //   right: 16,
          //   child: ScaleTransition(
          //     scale: _sosAnimation,
          //     child: FloatingActionButton(
          //       backgroundColor: Colors.red,
          //       onPressed: () {
          //         //  Navigator.pushNamed(context, AppRoutes.sos);
          //       },
          //       child: const Icon(
          //         Remix.alarm_warning_fill,
          //         color: Colors.white,
          //         size: 28,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Stack(
      children: [
        Image.network(
          "https://public.readdy.ai/gen_page/map_placeholder_1280x720.png",
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        // Current Location Marker
        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primary,
                child: CircleAvatar(radius: 6, backgroundColor: Colors.white),
              ),
            ],
          ),
        ),
        // Map Controls
        Positioned(
          top: 12,
          right: 12,
          child: Column(
            children: [
              _buildMapControlButton(icon: Remix.add_line),
              const SizedBox(height: 8),
              _buildMapControlButton(icon: Remix.subtract_line),
              const SizedBox(height: 8),
              _buildMapControlButton(icon: Remix.focus_3_line),
            ],
          ),
        ),
        // Accuracy Indicator
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Remix.radar_line, color: AppColors.primary, size: 16),
                const SizedBox(width: 4),
                Text(
                  "Accuracy: ${_accuracy.toStringAsFixed(1)}m",
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapControlButton({required IconData icon}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.poppins(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionText,
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafeZoneItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Remix.arrow_right_s_line, color: Colors.grey[400]),
            onPressed: () {
              // Navigate to safe zone details
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required String initials,
    required String name,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 20,
            child: Text(initials, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                Text(
                  status,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Remix.map_pin_user_line, color: AppColors.primary),
            onPressed: () {
              // Show contact on map
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShareLocationModal() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Share Your Location",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      icon: const Icon(Remix.close_line),
                      onPressed: _toggleShareModal,
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose how long to share your location with your emergency contacts:",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Share Time Options
                    Column(
                      children: [
                        _buildShareTimeOption(
                          value: "1h",
                          label: "1 hour",
                          isSelected: _selectedShareTime == "1h",
                        ),
                        _buildShareTimeOption(
                          value: "4h",
                          label: "4 hours",
                          isSelected: _selectedShareTime == "4h",
                        ),
                        _buildShareTimeOption(
                          value: "24h",
                          label: "24 hours",
                          isSelected: _selectedShareTime == "24h",
                        ),
                        _buildShareTimeOption(
                          value: "untilStop",
                          label: "Until I stop sharing",
                          isSelected: _selectedShareTime == "untilStop",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Share With Contacts
                    Text(
                      "Share with:",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    _buildContactCheckbox(
                      name: "Phani",
                      isSelected: _selectedContacts.contains("Phani"),
                    ),
                    _buildContactCheckbox(
                      name: "Jhansi",
                      isSelected: _selectedContacts.contains("Jhansi"),
                    ),
                    _buildContactCheckbox(
                      name: "Lavanya",
                      isSelected: _selectedContacts.contains("Lavanya"),
                    ),
                    const SizedBox(height: 16),
                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _startSharingLocation,
                        child: Text(
                          "Start Sharing Location",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareTimeOption({
    required String value,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedShareTime = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[200]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Remix.checkbox_circle_fill
                  : Remix.checkbox_blank_circle_line,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(label, style: GoogleFonts.poppins()),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCheckbox({
    required String name,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _toggleContactSelection(name),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              isSelected ? Remix.checkbox_fill : Remix.checkbox_blank_line,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(name),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sosAnimationController.dispose();
    super.dispose();
  }
}
