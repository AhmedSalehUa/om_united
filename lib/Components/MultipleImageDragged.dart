 import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';

class MultipleImageDragged extends StatefulWidget {
  final String text;
  final String url;
  final Function(List<PlatformFile> imgs) photos;

  const MultipleImageDragged({
    Key? key,
    required this.text,
    required this.photos,
    required this.url,
  }) : super(key: key);

  @override
  State<MultipleImageDragged> createState() => _MultipleImageDraggedState();
}

class _MultipleImageDraggedState extends State<MultipleImageDragged> {
  List<PlatformFile> _imageFiles = [];


  @override
  Widget build(BuildContext context) {

    Future<void> _pickImages() async {
      try {
        // Pick multiple image files using file_picker package
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'pdf', 'mp4'],
          allowMultiple: true,
        );

        // If user cancels the picker, do nothing
        if (result == null) return;

        // If user picks one or more images, update the state with the new image files
        setState(() {
          _imageFiles = result.files;
          widget.photos(result.files);
        });
      } catch (e) {
        // If there is an error, show a snackbar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
    return GestureDetector(
      onTap: _pickImages,
      child: DottedBorder(
        color: const Color(0xFF8690A8),
        padding: const EdgeInsets.all(10),
        dashPattern: [10, 5],
        radius: const Radius.circular(4),
        strokeWidth: .5,
        child: SizedBox(
          height: 148,
          child: _imageFiles.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageFiles.length,
                  itemBuilder: (BuildContext context, int index) {
                    PlatformFile taregtFile = _imageFiles[index];
                    return taregtFile.extension != "mp4"
                        ? kIsWeb
                            ? Image.memory(
                                Uint8List.fromList(taregtFile.bytes!),
                                width: 300,
                                height: 300,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(taregtFile!.path!),
                                width: 300,
                                height: 300,
                                fit: BoxFit.cover,
                              )
                        : DottedBorder(
                            child: Container(
                              width: 300,
                              height: 300,
                              child: Center(
                                child: Text("Video"),
                              ),
                            ),
                          );
                  },
                )
              : widget.url != ""
                  ? Image.network(widget.url)
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
