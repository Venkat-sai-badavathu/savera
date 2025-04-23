import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  bool _isEditMode = false;

  final List<Map<String, dynamic>> _essentialContacts = [
    {'name': 'Police', 'number': '100', 'icon': Remix.police_car_line},
    {'name': 'Ambulance', 'number': '108', 'icon': Remix.hospital_line},
    {'name': 'Fire Rescue', 'number': '101', 'icon': Remix.fire_line},
    {'name': 'Women Helpline', 'number': '1091', 'icon': Remix.women_line},
    {
      'name': 'Emergency Helpline',
      'number': '112',
      'icon': Remix.first_aid_kit_line,
    },
  ];

  List<Map<String, dynamic>> _personalContacts = [
    {'id': 1, 'name': 'Phani', 'number': '+91 9989577067'},
    {'id': 2, 'name': 'Jhansi', 'number': '+91 7075756456'},
    {'id': 3, 'name': 'Lavanya', 'number': '+91 8978993056'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Emergency Contacts',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Remix.check_line : Remix.edit_line),
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Essential Helplines'),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _essentialContacts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final contact = _essentialContacts[index];
                return _buildContactCard(
                  name: contact['name'],
                  number: contact['number'],
                  iconData: contact['icon'],
                  isEssential: true,
                );
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Your Emergency Contacts'),
            const SizedBox(height: 12),
            _personalContacts.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _personalContacts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final contact = _personalContacts[index];
                    return _buildContactCard(
                      name: contact['name'],
                      number: contact['number'],
                      isEssential: false,
                      onDelete:
                          _isEditMode
                              ? () => _showDeleteDialog(contact['id'])
                              : null,
                    );
                  },
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        backgroundColor: const Color(0xFFF75590),
        child: const Icon(Remix.add_line, color: Colors.white),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFF75590),
      ),
    );
  }

  Widget _buildContactCard({
    required String name,
    required String number,
    IconData? iconData,
    bool isEssential = false,
    VoidCallback? onDelete,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    isEssential
                        ? const Color(0xFFF75590).withOpacity(0.1)
                        : const Color(0xFFF75590),
                borderRadius: BorderRadius.circular(20),
              ),
              child:
                  isEssential
                      ? Icon(
                        iconData ?? Remix.user_line,
                        color: const Color(0xFFF75590),
                        size: 20,
                      )
                      : Center(
                        child: Text(
                          name.split(' ').map((e) => e[0]).join().toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                    number,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Remix.delete_bin_line, color: Colors.red),
                onPressed: onDelete,
              ),
            IconButton(
              icon: Icon(Remix.phone_line, color: const Color(0xFFF75590)),
              onPressed: () => _makePhoneCall(number),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECF1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF75590).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Remix.contacts_book_line,
              size: 32,
              color: Color(0xFFF75590),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No emergency contacts added yet',
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            'Add your trusted contacts for emergency situations',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final numberController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Emergency Contact'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Remix.user_line),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: numberController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      numberController.text.isNotEmpty) {
                    setState(() {
                      _personalContacts.add({
                        'id': DateTime.now().millisecondsSinceEpoch,
                        'name': nameController.text,
                        'number': numberController.text,
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF75590),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(int contactId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Contact'),
            content: const Text(
              'Are you sure you want to delete this contact?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _personalContacts.removeWhere(
                      (contact) => contact['id'] == contactId,
                    );
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone app')),
      );
    }
  }
}
