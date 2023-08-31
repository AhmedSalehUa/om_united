 import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
 import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ImageDragged extends StatefulWidget {
  final String text;
  final String url;

  final Function(PlatformFile img) photo;

  const ImageDragged(
      {Key? key, required this.text, required this.photo, required this.url})
      : super(key: key);

  @override
  State<ImageDragged> createState() => _ImageDraggedState();
}

class _ImageDraggedState extends State<ImageDragged> {
  @override
  void initState() {
    super.initState();
  }

  PlatformFile? _imageFile;

  Future<void> _pickImage() async {
    try {
      // Pick an image file using file_picker package
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      // If user cancels the picker, do nothing
      if (result == null) return;

      // If user picks an image, update the state with the new image file
      setState(() {
        _imageFile = result.files.first;
        widget.photo(result.files.first);
      });
    } catch (e) {
      // If there is an error, show a snackbar with the error message
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: DottedBorder(
        color: const Color(0xFF8690A8),
        padding: const EdgeInsets.all(10),
        dashPattern: [10, 5],
        radius: const Radius.circular(4),
        strokeWidth: .5,
        child: SizedBox(
          width: 148,
          height: 148,
          child: widget.url != "" && _imageFile == null
              ? Image.network(widget.url)
              : _imageFile != null
                  ? kIsWeb
                      ? Image.memory(
                          Uint8List.fromList(_imageFile!.bytes!),
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(_imageFile!.path!),
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF1A1A24),
                            fontSize: 14,
                            fontFamily: 'santo',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.10,
                          ),
                        ),
                        const Text(
                          'اختيار الصورة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF475467),
                            fontSize: 14,
                            fontFamily: 'santo',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
