import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool isScanned = false;
  bool flashOn = false;

  final MobileScannerController controller = MobileScannerController();

  final ImagePicker picker = ImagePicker();

  Future<void> uploadImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null || !mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Image selected')));

    // ഇവിടെ gallery image scan ചെയ്യാനുള്ള logic പിന്നീട് add ചെയ്യാം
  }

  void handleQrCode(String code) {
    if (isScanned) return;

    setState(() {
      isScanned = true;
    });

    controller.stop();

    debugPrint('QR Code: $code');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Scanned: $code',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    // ഇവിടെ backend API call ചെയ്യാം
    // ഉദാഹരണം:
    // verifyQr(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // CAMERA
          MobileScanner(
            controller: controller,
            fit: BoxFit.cover,
            onDetect: (capture) {
              if (capture.barcodes.isEmpty) return;

              final String? code = capture.barcodes.first.rawValue;

              if (code != null && code.isNotEmpty) {
                handleQrCode(code);
              }
            },
          ),

          // DARK OVERLAY
          Positioned.fill(child: CustomPaint(painter: ScannerOverlay())),

          // TOP BUTTONS
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        onPressed: () {
                          controller.toggleTorch();

                          setState(() {
                            flashOn = !flashOn;
                          });
                        },
                        icon: Icon(
                          flashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // TITLE
          Positioned(
            top: 145,
            left: 20,
            right: 20,
            child: const Column(
              children: [
                Text(
                  'Scan any QR code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Place the QR code inside the box',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // SCANNER CORNERS
          Center(
            child: SizedBox(
              width: 280,
              height: 280,
              child: CustomPaint(painter: ScannerCorners()),
            ),
          ),

          // BOTTOM CONTENT
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: uploadImage,
                    icon: const Icon(
                      Icons.photo_library_outlined,
                      color: Colors.black,
                      size: 18,
                    ),
                    label: const Text(
                      'Upload from gallery',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(220, 42),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),

                  const Text(
                    'Scan to pay securely',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

// DARK OVERLAY WITH CLEAR CENTER
class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.60);

    const double boxSize = 280;

    final Rect box = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: boxSize,
      height: boxSize,
    );

    final Path path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(box, const Radius.circular(20)));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// FOUR CORNERS
class ScannerCorners extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double length = 35;

    // TOP LEFT
    canvas.drawLine(const Offset(0, length), const Offset(0, 0), paint);

    canvas.drawLine(const Offset(0, 0), const Offset(length, 0), paint);

    // TOP RIGHT
    canvas.drawLine(
      Offset(size.width - length, 0),
      Offset(size.width, 0),
      paint,
    );

    canvas.drawLine(Offset(size.width, 0), Offset(size.width, length), paint);

    // BOTTOM LEFT
    canvas.drawLine(
      Offset(0, size.height - length),
      Offset(0, size.height),
      paint,
    );

    canvas.drawLine(Offset(0, size.height), Offset(length, size.height), paint);

    // BOTTOM RIGHT
    canvas.drawLine(
      Offset(size.width - length, size.height),
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, size.height - length),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
