import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ImageField extends StatefulWidget {
  const ImageField({super.key, required this.onFileChange});
  final ValueChanged<File?> onFileChange;
  @override
  State<ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends State<ImageField> {
  bool isLoading = false;
  File? fileImage;
  Uint8List? webImage;
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: () async {
          isLoading = true;
          setState(() {});
          try {
            await pickImage();
          } catch (e) {
            // Handle any errors that might occur
          } finally {
            // Always reset loading state
            isLoading = false;
            setState(() {});
          }
        },
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey),
              ),
              child: (kIsWeb && webImage != null)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(webImage!),
                    )
                  : (fileImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(fileImage!),
                        )
                      : const Icon(
                          Icons.image_outlined,
                          size: 180,
                        )),
            ),
            Visibility(
              visible: (kIsWeb && webImage != null) || fileImage != null,
              child: IconButton(
                  onPressed: () {
                    fileImage = null;
                    webImage = null;
                    widget.onFileChange(null);
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.remove_circle_outline_outlined,
                    color: Colors.red,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (!mounted) return;
      if (kIsWeb) {
        var bytes = await image.readAsBytes();
        webImage = bytes;
        fileImage = null;
        widget.onFileChange(null); // أو مرر البايتات إذا أردت
        setState(() {});
      } else {
        fileImage = File(image.path);
        webImage = null;
        widget.onFileChange(fileImage!);
        setState(() {});
      }
    }
  }
}
