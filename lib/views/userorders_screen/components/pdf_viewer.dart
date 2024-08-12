import 'package:flutter/material.dart';
import 'package:flutter_application_2/consts/colors.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: Color(0xFFDAD3BE),     
    iconTheme: const IconThemeData(color: Colors.white),
        title: Text('PDF Viewer'),
      ),
      body: SafeArea(
        child: SfPdfViewer.network(
          pdfUrl,
          // Optionally, you can customize the PDF viewer with more properties here
        ),
      ),
    );
  }
}
