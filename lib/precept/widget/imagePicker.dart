import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:precept_client/precept/binding/converter.dart';

/// Widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  final String logoUrl;
  final bool readOnly;
  final String storageBucket;
  final String storageFilePath;
  final ModelConnector<String, String> imageConnector;

  const ImageCapture(
      {Key key,
      @required this.logoUrl,
      this.readOnly = true,
      this.storageBucket,
      this.storageFilePath,
      @required this.imageConnector})
      : assert(readOnly || storageFilePath != null),
        assert(readOnly || storageBucket != null),
        super(key: key);

  createState() => _ImageCaptureState();
}

enum ImageCapturePattern { uploadFromCamera, uploadFromGallery }

class ImageCapturePatterns {
  Map<dynamic, String> get patterns => {
        ImageCapturePattern.uploadFromCamera: "Upload from camera",
        ImageCapturePattern.uploadFromGallery: "Upload from Gallery",
      };
}

enum UploadState { notStarted, selected, uploaded }

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File _imageFile;
  UploadState uploadState;
  String logoUrl;

  initState() {
    super.initState();
    uploadState = UploadState.notStarted;
    logoUrl = widget.logoUrl;
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    /// [issue](https://gitlab.com/club.kayman/frontend/-/issues/275)

    // ignore: deprecated_member_use
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
      uploadState = UploadState.selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (uploadState) {
      case UploadState.notStarted:
      case UploadState.uploaded:
        return Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 2.0, bottom: 2.0, left: 2, right: 2),
                  child: Image.network(
                    logoUrl,
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ),
            (widget.readOnly)
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.camera_alt),
//                      i18nKey: ImageCapturePattern.uploadFromCamera,
                            onPressed: () => onUpload(ImageSource.camera)),
                        IconButton(
                            icon: Icon(Icons.file_upload),
//                      i18nKey: ImageCapturePattern.uploadFromGallery,
                            onPressed: () => onUpload(ImageSource.gallery)),
                      ],
                    ),
                  ),
          ],
        );
      case UploadState.selected:
        return Column(children: [
          Uploader(
            onCompleted: uploadCompleted,
            storageFilePath: widget.storageFilePath,
            storageBucket: widget.storageBucket,
            file: _imageFile,
          )
        ]);
    }
    return null; // Unreachable
  }

  onUpload(ImageSource source) {
    _pickImage(source);
  }

  uploadCompleted(StorageReference storageReference) async {
    final String url = await storageReference.getDownloadURL();
    setState(() {
      logoUrl = url;
      widget.imageConnector.writeToModel(url);
      uploadState = UploadState.uploaded;
    });
  }
}

/// Uploads [file] to Google Cloud Storage at the location specified by [storageBucket] and [storageFilePath]
/// [onCompleted] - fired when upload task has completed
class Uploader extends StatefulWidget {
  final File file;
  final String storageBucket;
  final String storageFilePath;
  final Function(StorageReference) onCompleted;
  final String completeMessage;

  Uploader(
      {Key key,
      @required this.file,
      @required this.storageBucket,
      @required this.storageFilePath,
      this.onCompleted,
      this.completeMessage = "Upload complete"})
      : assert(storageBucket != null),
        assert(file != null),
        super(key: key);

  createState() => _UploaderState();
}

enum UploaderPatterns { uploadComplete }

class _UploaderState extends State<Uploader> {
  FirebaseStorage _storage;
  StorageUploadTask _uploadTask;

  initState() {
    super.initState();
    _storage = FirebaseStorage(storageBucket: widget.storageBucket);
    _uploadTask =
        _storage.ref().child(widget.storageFilePath).putFile(widget.file);
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;
            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;
            if (_uploadTask.isComplete && widget.onCompleted != null) {
              widget.onCompleted(_storage.ref().child(widget.storageFilePath));
            }

            return Center(
              child: Container(
                width: 200,
                height: 100,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(value: progressPercent),
                      if (_uploadTask.isPaused)
                        Container(
                          width: 60,
                          height: 30,
                          child: FlatButton(
                            child: Icon(Icons.play_arrow, size: 25),
                            onPressed: _uploadTask.resume,
                          ),
                        ),
                      if (_uploadTask.isInProgress)
                        Container(
                          width: 60,
                          height: 30,
                          child: FlatButton(
                            child: Icon(Icons.pause, size: 25),
                            onPressed: _uploadTask.pause,
                          ),
                        ),
                      if (_uploadTask.isComplete)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(widget.completeMessage),
                        )
                    ]),
              ),
            );
          });
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
