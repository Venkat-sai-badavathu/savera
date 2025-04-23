import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../routes.dart';
import '../utils/colors.dart';

class MomentCaptureScreen extends StatefulWidget {
  const MomentCaptureScreen({Key? key}) : super(key: key);

  @override
  _MomentCaptureScreenState createState() => _MomentCaptureScreenState();
}

class _MomentCaptureScreenState extends State<MomentCaptureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isFrontCamera = true;
  XFile? _capturedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = Future.value();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameraStatus = await Permission.camera.request();
    final galleryStatus = await Permission.photos.request();

    if (cameraStatus.isGranted) {
      final cameras = await availableCameras();
      final selectedCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras[0],
      );

      _controller = CameraController(selectedCamera, ResolutionPreset.medium);
      _initializeControllerFuture = _controller!.initialize();
      setState(() {});
    } else if (cameraStatus.isPermanentlyDenied ||
        galleryStatus.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera and gallery permissions are required'),
        ),
      );
    }
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName =
          'moment_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(appDir.path, fileName);

      final XFile picture = await _controller!.takePicture();
      await picture.saveTo(filePath);

      setState(() {
        _capturedImage = XFile(filePath);
      });

      _showPreviewDialog(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture: ${e.toString()}')),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (image != null) {
        // Create a copy in app directory for consistency
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName =
            'gallery_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String newPath = path.join(appDir.path, fileName);

        await File(image.path).copy(newPath);
        _showPreviewDialog(newPath);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  void _showPreviewDialog(String imagePath) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              'Image Selected',
              style: TextStyle(fontFamily: 'Poppins', color: AppColors.primary),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(
                  File(imagePath),
                ), // Use FileImage for better performance
                const SizedBox(height: 16),
                Text(
                  'What would you like to do?',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.imageResponse,
                    arguments: imagePath,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text(
                  'Get Safety Suggestions',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _toggleCamera() async {
    final cameras = await availableCameras();
    final newCamera =
        _isFrontCamera
            ? cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
              orElse: () => cameras[0],
            )
            : cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front,
              orElse: () => cameras[0],
            );

    await _controller?.dispose();
    _controller = CameraController(newCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller!.initialize();

    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Moment Capture',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _controller != null &&
              _controller!.value.isInitialized) {
            return Stack(
              children: [
                CameraPreview(_controller!),
                Positioned(
                  bottom: 100, // Adjusted to make space for gallery button
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        onPressed: _takePicture,
                        backgroundColor: AppColors.primary,
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      FloatingActionButton(
                        onPressed: _toggleCamera,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.flip_camera_android,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                // New Gallery Button at bottom
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: _pickImageFromGallery,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: BorderSide(color: AppColors.primary),
                      ),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('View Gallery'),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Camera error: ${snapshot.error}'),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.photo_library, color: Colors.white),
                    label: const Text(
                      'Select from Gallery',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.photo_library, color: Colors.white),
                    label: const Text(
                      'Select from Gallery',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
