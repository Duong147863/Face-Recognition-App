
import 'package:camera/camera.dart';

class UtilsScanner {
  UtilsScanner._();

  static Future<CameraDescription> getCamera(CameraLensDirection lensDirection) async {
    final cameras = await availableCameras();
    return cameras.firstWhere(
      (camera) => camera.lensDirection == lensDirection,
      orElse: () => cameras.first,
    );
  }
}