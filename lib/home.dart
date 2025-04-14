
// import 'dart:async';
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class Home extends StatefulWidget {
//   final String? name;
//   const Home({super.key, this.name});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   CameraController? _cameraController;
//   late List<CameraDescription> cameras;
//   bool _isCameraInitialized = false;
//   String _serverResponse = "Waiting for response...";
//   CameraLensDirection cameraDirection = CameraLensDirection.front;
//   bool isProcessing = false;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   Future<void> _initCamera() async {
//     cameras = await availableCameras();
//     _cameraController = CameraController(
//       cameras.firstWhere((cam) => cam.lensDirection == cameraDirection),
//       ResolutionPreset.medium,
//     );

//     await _cameraController!.initialize();
//     setState(() => _isCameraInitialized = true);

//     // Bắt đầu quét tự động mỗi 5 giây
//     _startFaceDetection();
//   }

//   void _startFaceDetection() {
//     _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       if (!isProcessing) {
//         _captureAndSaveImage();
//       }
//     });
//   }

//   Future<void> _captureAndSaveImage() async {
//     if (!_isCameraInitialized || _cameraController == null || isProcessing) return;

//     setState(() => isProcessing = true);

//     try {
//       final XFile image = await _cameraController!.takePicture();

//       // Lưu ảnh vào thư mục ứng dụng với tên người dùng
//       final Directory appDir = await getApplicationDocumentsDirectory();
//       String imageName = "${widget.name ?? 'user'}.png";  // Nếu không có tên, lưu thành 'user.png'
//       final File savedImage = await File(image.path).copy("${appDir.path}/$imageName");

//       // Gửi ảnh đến server
//       await _sendImageToServer(savedImage);

//     } catch (e) {
//       setState(() {
//         _serverResponse = "Error: $e";
//         isProcessing = false;
//       });
//     }
//   }

//   Future<void> _sendImageToServer(File imageFile) async {
//     try {
//       var request = http.MultipartRequest(
//         'POST',
//          Uri.parse("http://10.3.249.60:5000/zzzzz"),
//       );
//       request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

//       var response = await request.send();
//       var responseData = await response.stream.bytesToString();
//       var jsonResponse = json.decode(responseData);

//       setState(() {
//         _serverResponse = jsonResponse.toString();
//         isProcessing = false;
//       });
//     } catch (e) {
//       setState(() {
//         _serverResponse = "Error: $e";
//         isProcessing = false;
//       });
//     }
//   }

//   Widget _buildCameraPreview() {
//     if (!_isCameraInitialized || _cameraController == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 3 / 4,
//       width: double.infinity,
//       child: Transform.scale(
//         scaleX: cameraDirection == CameraLensDirection.front ? -1 : 1,
//         child: RotatedBox(
//           quarterTurns: cameraDirection == CameraLensDirection.back
//               ? (Platform.isAndroid ? 1 : 0)
//               : (Platform.isAndroid ? 3 : 2),
//           child: CameraPreview(_cameraController!),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           _buildCameraPreview(),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Text("Server Response: $_serverResponse"),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  final String? name;
  const Home({super.key, this.name});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  bool _isCameraInitialized = false;
  String _serverResponse = "Waiting for response...";
  CameraLensDirection cameraDirection = CameraLensDirection.front;
  bool isProcessing = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.firstWhere((cam) => cam.lensDirection == cameraDirection),
      ResolutionPreset.medium,
    );

    await _cameraController!.initialize();
    setState(() => _isCameraInitialized = true);
    
    _startFaceDetection();
  }

  void _startFaceDetection() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!isProcessing) {
        _captureAndSaveImage();
      }
    });
  }

  Future<void> _captureAndSaveImage() async {
    if (!_isCameraInitialized || _cameraController == null || isProcessing) return;

    setState(() => isProcessing = true);

    try {
      final XFile image = await _cameraController!.takePicture();

      final Directory appDir = await getApplicationDocumentsDirectory();
      String imageName = "${widget.name ?? 'user'}.png";
      final File savedImage = await File(image.path).copy("${appDir.path}/$imageName");

      await _sendImageToServer(savedImage);
    } catch (e) {
      setState(() {
        _serverResponse = "Error: $e";
        isProcessing = false;
      });
    }
  }

  Future<void> _sendImageToServer(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://192.168.1.71:5000/zzzzz"),
      );
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      setState(() {
        _serverResponse = jsonResponse.toString();
        isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _serverResponse = "Error: $e";
        isProcessing = false;
      });
    }
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 3 / 4,
          width: double.infinity,
          child: Transform.scale(
            scaleX: cameraDirection == CameraLensDirection.front ? -1 : 1,
            child: RotatedBox(
              quarterTurns: cameraDirection == CameraLensDirection.back
                  ? (Platform.isAndroid ? 1 : 0)
                  : (Platform.isAndroid ? 3 : 2),
              child: CameraPreview(_cameraController!),
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: OvalFramePainter(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildCameraPreview(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("Server Response: $_serverResponse"),
          ),
        ],
      ),
    );
  }
}

class OvalFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    Rect rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.8,
      height: size.height * 0.7, // Bóp nhỏ chiều dài khung bầu dục
    );

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}