import 'package:flutter/material.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/converter.dart';
import 'package:precept/precept/part/part.dart';
import 'package:precept/precept/widget/caption.dart';
import 'package:precept/precept/widget/imagePicker.dart';

enum DisplayType { text, datePicker }

/// Input data type: [Url]
/// Read only display: [Image]
/// Edit mode display: [File upload]
/// See [Part]
/// [caption] should be an I18N key
class ImagePart extends Part<String, ReadOnlyOptions, ImageEditModeOptions> {
  final String defaultLogoUrl;

  const ImagePart({
    this.defaultLogoUrl,
    Key key,
    bool readOnly,
    @required StringBinding binding,
    String caption,
    IconData icon,
    EdgeInsets padding = const EdgeInsets.only(bottom: 8.0),
    ReadOnlyOptions readOnlyOptions = const ReadOnlyOptions(),
    @required ImageEditModeOptions editModeOptions,
  }) : super(
          key: key,
          binding: binding,
          caption: caption,
          icon: icon,
          padding: padding,
          readOnlyOptions: readOnlyOptions,
          editModeOptions: editModeOptions,
          sourceDataType: SourceDataType.string,
        );

  Widget buildReadOnlyWidget(BuildContext context) {
    final connector = ModelConnector<String, String>(
        binding: binding, converter: PassThroughConverter<String>());
    final String logoUrl =
        connector.readFromModelOverridingDefaults(defaultValue: defaultLogoUrl);
    return Column(
      children: <Widget>[
        (readOnlyOptions.showCaption)
            ? Align(
                alignment: Alignment.centerLeft,
                child: I18NCaption(
                  text: caption,
                ),
              )
            : Container(),
        ImageCapture(
          logoUrl: logoUrl,
          readOnly: true,
          imageConnector: connector,
        ),
      ],
    );
  }

  Widget buildEditModeWidget(BuildContext context) {
    final connector = ModelConnector<String, String>(
        binding: binding, converter: PassThroughConverter<String>());
    final String logoUrl =
        connector.readFromModelOverridingDefaults(defaultValue: defaultLogoUrl);
    return Column(
      children: <Widget>[
        (editModeOptions.showCaption)
            ? Align(
                alignment: Alignment.centerLeft,
                child: I18NCaption(
                  text: caption,
                ),
              )
            : Container(),
        ImageCapture(
          imageConnector: connector,
          storageBucket: editModeOptions.storageBucket,
          storageFilePath: editModeOptions.storageFilePath,
          readOnly: false,
          logoUrl: logoUrl,
        ),
      ],
    );
  }
}

class ImageEditModeOptions extends EditModeOptions {
  final String storageBucket;
  final String storageFilePath;

  const ImageEditModeOptions(
      {@required this.storageBucket,
      @required this.storageFilePath,
      bool showColumnHeading = true,
      bool showCaption = true})
      : super(showCaption: showCaption, showColumnHeading: showColumnHeading);
}
