import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageHelper {
  ImageHelper({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
}): _imagePicker = imagePicker ?? ImagePicker(),
    _imageCropper = imageCropper ?? ImageCropper();

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  Future<XFile?> pickImage({
     ImageSource source = ImageSource.gallery,
      int imageQuality = 100,
}) async {
    return  await _imagePicker.pickImage(
      source: source,
      imageQuality: imageQuality,
    );
  }
  Future<CroppedFile?> crop({
    required XFile file,
    CropStyle cropStyle = CropStyle.rectangle,
    }) async {
    return await _imageCropper.cropImage(
      sourcePath: file.path,
        cropStyle: cropStyle,
      //   aspectRatioPresets: [
      //     CropAspectRatioPreset.square,
      //     CropAspectRatioPreset.ratio3x2,
      //     CropAspectRatioPreset.original,
      //     CropAspectRatioPreset.ratio4x3,
      //     CropAspectRatioPreset.ratio16x9
      //   ],
      // aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      // compressFormat: ImageCompressFormat.jpg,
      // //compress quality
      // compressQuality: 100,
    );

  }


}