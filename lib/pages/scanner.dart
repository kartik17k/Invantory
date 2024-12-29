import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:invantory/pages/productdetailsscreen.dart';
import '../data/productData.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey();
  QRViewController? controller;
  Barcode? result;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isProcessing = false; // Debounce flag

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 10).animate(_animationController);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.grey[900],
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.redAccent),
              SizedBox(width: 10),
              Text('Error', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Text(message, style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.tealAccent)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        primaryColor: Colors.indigo[700],
        scaffoldBackgroundColor: Colors.black,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'QR Code Scanner',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.tealAccent),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.tealAccent,
                borderRadius: 20,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
                overlayColor: Colors.black87,
              ),
              onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
            ),
            // Scanning animation
            Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 2,
                    margin: EdgeInsets.only(bottom: _animation.value),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.tealAccent.withOpacity(0),
                          Colors.tealAccent,
                          Colors.tealAccent.withOpacity(0),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Status container
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[900]?.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.tealAccent,
                        ),
                        SizedBox(width: 10),
                        Text(
                          result != null
                              ? 'Product ID: ${result!.code}'
                              : 'Scanning for QR Code...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;

    ctrl.scannedDataStream.listen((scanData) async {
      if (isProcessing) return; // Ignore if already processing
      if (result?.code == scanData.code) return; // Avoid duplicate processing

      setState(() {
        result = scanData;
      });

      final productId = result?.code;
      if (productId != null && ProductData.products.containsKey(productId)) {
        isProcessing = true; // Start processing
        controller?.pauseCamera(); // Pause camera

        await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ProductDetailsScreen(productId: productId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );

        // Reset the scanner state after navigation
        setState(() {
          result = null;
        });

        controller?.resumeCamera(); // Resume camera
        isProcessing = false; // Reset processing flag
      } else {
        _showErrorDialog('Invalid Product ID! Please scan a valid product QR code.');
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isProcessing = false; // Reset processing flag
            result = null; // Clear scanned data
          });
        });
      }
    });
  }


  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool permission) {
    if (!permission) {
      _showErrorDialog(
        'Camera permission is required to scan QR codes. Please enable it in your device settings.',
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
