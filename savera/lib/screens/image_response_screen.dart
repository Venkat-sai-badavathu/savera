import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/colors.dart';
import 'package:path/path.dart' as path;

class ImageResponseScreen extends StatefulWidget {
  final String imagePath;

  const ImageResponseScreen({Key? key, required this.imagePath})
    : super(key: key);

  @override
  _ImageResponseScreenState createState() => _ImageResponseScreenState();
}

class _ImageResponseScreenState extends State<ImageResponseScreen> {
  String _response = '';
  bool _isLoading = false;

  Future<void> _analyzeImage() async {
    setState(() => _isLoading = true);

    try {
      final apiUrl = dotenv.get(
        'PANIC_DETECT_API_URL',
        fallback: 'http://192.168.42.139:5000/api/panic-detect',
      );

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          widget.imagePath,
          filename: path.basename(widget.imagePath),
        ),
      );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      print('📡 Status Code: ${response.statusCode}');
      print('🔁 Backend Response: $responseData');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseData);
        setState(() {
          _response =
              jsonResponse['suggestion'] ??
              'No specific safety suggestions available.';
        });
      } else {
        setState(() {
          _response = 'Error: ${response.statusCode}\n$responseData';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Connection error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Safety Analysis',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Captured Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: FileImage(File(widget.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Analysis Section
            Text(
              'Safety Assessment:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 10),

            _isLoading
                ? Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
                : Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _response,
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                  ),
                ),

            SizedBox(height: 20),
            if (!_isLoading)
              Center(
                child: ElevatedButton(
                  onPressed: _analyzeImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Re-analyze',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
