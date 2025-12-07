import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frontend/models/certificate.dart';
import 'package:frontend/providers/certificate_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CertificateScreen extends StatefulWidget {
  final Certificate? certificate;

  const CertificateScreen({super.key, this.certificate});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  File? _selectedImage;
  String? _existingImageBase64;

  @override
  void initState() {
    super.initState();
    if (widget.certificate != null && widget.certificate!.imageUrl != null && widget.certificate!.imageUrl!.isNotEmpty) {
      _existingImageBase64 = widget.certificate!.imageUrl;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _existingImageBase64 = null;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      String? base64Image;

      if (_selectedImage != null) {
        final bytes = await _selectedImage!.readAsBytes();
        base64Image = base64Encode(bytes);
      } else if (_existingImageBase64 != null &&
          _existingImageBase64!.isNotEmpty) {
        base64Image = _existingImageBase64;
      }

      final certificateData = {
        "name": values['name'],
        "imageUrl": base64Image ?? '',
        "tutorId": AuthService().user?.id,
        "languageId": 1, // Defaulting to 1 as per previous logic
      };

      try {
        final certificateProvider = Provider.of<CertificateProvider>(context, listen: false);

        if (widget.certificate != null) {
          await certificateProvider.update(widget.certificate!.id, certificateData);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Certificate updated successfully')),
          );
        } else {
          await certificateProvider.insert(certificateData);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Certificate added successfully')),
          );
        }

        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.certificate != null ? 'EDIT CERTIFICATE' : 'ADD CERTIFICATE',
                      style: const TextStyle(
                        color: Color(0xFFB000FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFFB000FF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Form
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      const Text(
                        'Certificate Name',
                        style: TextStyle(
                          color: Color(0xFFB000FF),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: 'name',
                        initialValue: widget.certificate?.name ?? '',
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter certificate name...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'This field is required.' : null,
                      ),

                      const SizedBox(height: 20),

                      // Image
                      const Text(
                        'Certificate Image',
                        style: TextStyle(
                          color: Color(0xFFB000FF),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : _existingImageBase64 != null && _existingImageBase64!.isNotEmpty
                                  ? _buildImageFromBase64(_existingImageBase64!)
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.image_outlined,
                                          color: Color(0xFFB000FF),
                                          size: 60,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Tap to add image',
                                          style: TextStyle(
                                            color: Color(0xFFB000FF),
                                          ),
                                        ),
                                      ],
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A1B9A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: Text(
                      widget.certificate != null ? 'UPDATE' : 'SAVE',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageFromBase64(String base64String) {
    try {
      final base64RegExp = RegExp(r'data:image/[^;]+;base64,');
      String pureBase64 = base64String.replaceAll(base64RegExp, '');
      final bytes = base64Decode(pureBase64);
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          bytes,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(Icons.broken_image, color: Colors.grey, size: 48),
          ),
        ),
      );
    } catch (e) {
      return const Center(
        child: Icon(Icons.broken_image, color: Colors.grey, size: 48),
      );
    }
  }
}
