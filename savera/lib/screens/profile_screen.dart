import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remixicon/remixicon.dart';
import '../routes.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  final bool isEditMode;

  const ProfileScreen({super.key, this.isEditMode = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isEditMode;
  }

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Profile data
  String _profileImage = 'https://example.com/profile.jpg'; // Default image URL
  String _fullName = 'Savera';
  String _mobile = '+91 9876543210';
  int _age = 21;
  String _dob = '2003-08-12';
  String _address = 'Flat No 101, XYZ Road, Vijayawada';
  String _country = 'India';
  String _state = 'Telangana';
  String _district = 'Warangal';
  final List<Map<String, String>> _emergencyContacts = [
    {'name': 'Phani', 'phone': '+91 8765432109'},
    {'name': 'Jhansi', 'phone': '+91 7654321098'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Savera',
                  style: GoogleFonts.pacifico(
                    fontSize: 20,
                    color: const Color(0xFFF75590),
                  ),
                ),
              ),
            ),
            Text(
              '       Profile',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(child: Container()), // Empty space to push the text
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.close : Remix.edit_line,
              color: const Color(0xFFF75590),
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
        elevation: 1,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Header
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFF75590),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            _profileImage,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => const Icon(
                                  Remix.user_line,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showImagePickerOptions,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF75590),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Remix.camera_line,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _fullName,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stay Safe, Stay Strong',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Personal Information
              _buildSectionHeader('Personal Information'),
              _buildEditableField(
                label: 'Full Name',
                value: _fullName,
                icon: Remix.user_line,
                onChanged: (value) => _fullName = value,
                isEditing: _isEditing,
              ),
              _buildEditableField(
                label: 'Mobile Number',
                value: _mobile,
                icon: Remix.phone_line,
                keyboardType: TextInputType.phone,
                onChanged: (value) => _mobile = value,
                isEditing: _isEditing,
              ),
              if (_isEditing)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: _showChangePasswordDialog,
                    child: Text(
                      'Change Password',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFF75590),
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: _buildEditableField(
                      label: 'Age',
                      value: _age.toString(),
                      icon: Remix.calendar_line,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _age = int.tryParse(value) ?? _age,
                      isEditing: _isEditing,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildEditableField(
                      label: 'Date of Birth',
                      value: _dob,
                      icon: Remix.calendar_event_line,
                      isDateField: true,
                      onChanged: (value) => _dob = value,
                      isEditing: _isEditing,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Location Information
              _buildSectionHeader('Location Information'),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      MediaQuery.of(context).size.width > 400 ? 16.0 : 12.0,
                ),
                child: Column(
                  children: [
                    _buildEditableField(
                      label: 'Address',
                      value: _address,
                      icon: Remix.map_pin_line,
                      onChanged: (value) => _address = value,
                      isEditing: _isEditing,
                    ),
                    _buildEditableField(
                      label: 'Country',
                      value: _country,
                      icon: Remix.globe_line,
                      isEditing: false,
                      onChanged: (String) {}, // Country is not editable
                    ),
                    const SizedBox(height: 12), // spacing between dropdowns
                    _buildEditableDropdown(
                      label: 'State',
                      value: _state,
                      items: const [
                        'Telangana',
                        'Andhra Pradesh',
                        'Karnataka',
                        'Tamil Nadu',
                        'Maharashtra',
                      ],
                      onChanged: (value) {
                        setState(() {
                          _state = value!;
                          _district = 'Select district';
                        });
                      },
                      isEditing: _isEditing,
                    ),
                    const SizedBox(height: 12),
                    _buildEditableDropdown(
                      label: 'District',
                      value: _district,
                      items: _getDistrictsForState(_state),
                      onChanged: (value) => setState(() => _district = value!),
                      isEditing: _isEditing,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Emergency Contacts
              _buildSectionHeader('Emergency Contacts'),
              ..._emergencyContacts.map(
                (contact) => _buildEmergencyContactCard(
                  name: contact['name']!,
                  phone: contact['phone']!,
                  onDelete:
                      _isEditing
                          ? () => _showDeleteContactDialog(contact['name']!)
                          : null,
                ),
              ),
              if (_isEditing)
                OutlinedButton(
                  onPressed: _showAddContactDialog,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Remix.add_line,
                        size: 16,
                        color: Color(0xFFF75590),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Add Emergency Contact',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFF75590),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Edit Mode Buttons
              if (_isEditing)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF75590),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Profile tab is active
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          } else if (index == 2) {
            // Already on profile
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, AppRoutes.map);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, AppRoutes.settings);
          } else {
            // Handle other tabs
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFF75590),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Remix.home_line), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Remix.map_2_line), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Remix.user_fill),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required String value,
    required IconData icon,
    bool isEditing = false,
    bool isDateField = false,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color:
                  isEditing
                      ? const Color(0xFFF75590).withOpacity(0.05)
                      : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border:
                  isEditing
                      ? Border.all(
                        color: const Color(0xFFF75590).withOpacity(0.2),
                      )
                      : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child:
                        isEditing && !isDateField
                            ? TextFormField(
                              initialValue: value,
                              keyboardType: keyboardType,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onChanged: onChanged,
                            )
                            : isEditing && isDateField
                            ? InkWell(
                              onTap: () => _selectDate(context),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Text(
                                  value,
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            )
                            : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(value, style: GoogleFonts.poppins()),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required bool isEditing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color:
                  isEditing
                      ? const Color(0xFFF75590).withOpacity(0.05)
                      : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border:
                  isEditing
                      ? Border.all(
                        color: const Color(0xFFF75590).withOpacity(0.2),
                      )
                      : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.white, // Dropdown background
                      ),
                      child: DropdownButtonFormField<String>(
                        value: value,
                        items:
                            items.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color:
                                        Colors
                                            .black, // Font color inside dropdown
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: isEditing ? onChanged : null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        icon: const Icon(Remix.arrow_down_s_line),
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Selected value text color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactCard({
    required String name,
    required String phone,
    VoidCallback? onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Remix.user_line, color: Colors.grey),
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
                    phone,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Remix.delete_bin_line, color: Colors.grey),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_dob),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dob =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        _age = DateTime.now().year - picked.year;
      });
    }
  }

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Remix.camera_line),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Remix.image_line),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Remix.close_line),
                  title: const Text('Cancel'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        // In a real app, you would upload the image to your server
        setState(() {
          _profileImage = pickedFile.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    prefixIcon: Icon(Remix.lock_line),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: Icon(Remix.lock_line),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    prefixIcon: Icon(Remix.lock_line),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // In a real app, you would validate and change the password
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password updated successfully'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF75590),
                ),
                child: const Text('Update Password'),
              ),
            ],
          ),
    );
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Emergency Contact'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Name',
                    prefixIcon: Icon(Remix.user_line),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Remix.phone_line),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      phoneController.text.isNotEmpty) {
                    setState(() {
                      _emergencyContacts.add({
                        'name': nameController.text,
                        'phone': phoneController.text,
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contact added successfully'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF75590),
                ),
                child: const Text('Add Contact'),
              ),
            ],
          ),
    );
  }

  void _showDeleteContactDialog(String name) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Contact'),
            content: Text(
              'Are you sure you want to remove $name from your emergency contacts?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _emergencyContacts.removeWhere(
                      (contact) => contact['name'] == name,
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contact removed successfully'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  List<String> _getDistrictsForState(String state) {
    List<String> districts;
    switch (state) {
      case 'Telangana':
        districts = [
          'Warangal',
          'Hyderabad',
          'Karimnagar',
          'Khammam',
          'Nizamabad',
        ];
        break;
      case 'Andhra Pradesh':
        districts = [
          'Visakhapatnam',
          'Vijayawada',
          'Guntur',
          'Nellore',
          'Tirupati',
        ];
        break;
      case 'Karnataka':
        districts = ['Bangalore', 'Mysore', 'Hubli', 'Mangalore', 'Belgaum'];
        break;
      case 'Tamil Nadu':
        districts = [
          'Chennai',
          'Coimbatore',
          'Madurai',
          'Salem',
          'Tiruchirappalli',
        ];
        break;
      case 'Maharashtra':
        districts = ['Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Aurangabad'];
        break;
      default:
        districts = [];
    }
    return ['Select district', ...districts];
  }
}
