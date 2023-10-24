import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PdfGenerator {
  Future<Uint8List> generatePDF(requestData) async {
    final pdf = pw.Document();

    final nom_evenement = requestData['nom_evenement'];
    final localisation = requestData['localisation'];
    final date_evenement = requestData['date_evenement'];
    final nom_apartenant = requestData['nom_apartenant'];
    final type_ticket = requestData['type_ticket'];
    final image = await getImageFromUrl(requestData['image']); // Remplacez par votre URL d'image
    final logo = await getImageFromUrl('https://census.alwaysdata.net/logo_eventime.png'); // Remplacez par votre URL d'image
    final qrCodeImage = await getImageFromUrl(requestData['scanImage']); // Remplacez par votre URL



    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              image: pw.DecorationImage(image: image, fit: pw.BoxFit.cover),
            ),
            child: pw.Center(
              child: pw.Column(
                children: [
                  // Barre noire
                  pw.Container(// Couleur noire
                    height: 80.0,
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFF1F2230),
                    ),
                    child: pw.Center(
                        child: pw.Container(
                          height: 50,
                          decoration: pw.BoxDecoration(
                            image: pw.DecorationImage(image: logo, fit: pw.BoxFit.contain),
                          ),
                        )
                    ),
                  ),
                  pw.SizedBox(height: 70.0), // Espacement entre la barre noire et le cadre blanc
                  // Cadre blanc
                  // Cadre blanc
                  pw.Container(
                    color: PdfColor.fromInt(0xFFFFFFFF), // Couleur blanche
                    width: 380.0,
                    height: 500.0,
                    padding: const pw.EdgeInsets.all(20.0),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Texte centré
                        pw.Center(
                          child: pw.Text(nom_evenement,
                              style: pw.TextStyle(fontSize: 30.0)),
                        ),
                        pw.SizedBox(height: 20.0), // Espacement
                        // Deux textes à gauche
                        pw.Text(localisation,
                            style: pw.TextStyle(
                                fontSize: 12.0, color: PdfColors.grey800)),
                        pw.Text(formatDateTime(date_evenement),
                            style: pw.TextStyle(
                                fontSize: 12.0, color: PdfColors.grey800)),
                        // Diviseur
                        pw.Divider(
                          color: PdfColor.fromInt(0xFF7CA36A), // Couleur verte
                        ),
                        pw.SizedBox(height: 10.0), // Espacement
                        // Barre verte arrondie
                        pw.Container(
                          height: 60.0,
                          width: 350.0,
                          decoration: pw.BoxDecoration(
                              color: PdfColor.fromInt(0xFF7CA36A), // Couleur verte
                              borderRadius: pw.BorderRadius.circular(10)
                          ),
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            nom_apartenant,
                            style: pw.TextStyle(fontSize: 30.0, color: PdfColors.white),
                          ),
                        ),
                        pw.SizedBox(height: 20.0), // Espacement
                        // Texte en bas
                        pw.Center(
                          child: pw.Text(type_ticket,
                              style: pw.TextStyle(fontSize: 20.0)),
                        ),
                        pw.SizedBox(height: 10.0), // Espacement
                        // QR Code
                        pw.Center(
                            child: pw.Container(
                              height: 200,
                              decoration: pw.BoxDecoration(
                                image: pw.DecorationImage(image: qrCodeImage, fit: pw.BoxFit.contain),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<pw.MemoryImage> getImageFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return pw.MemoryImage(response.bodyBytes);
    } else {
      throw Exception('Failed to load image');
    }
  }

  String formatDateTime(String inputDateTime) {
    final dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(inputDateTime);
    final formattedDate = DateFormat.yMMMMd().format(dateTime);
    final formattedTime = DateFormat.Hm().format(dateTime);
    final formattedString = '$formattedDate à $formattedTime';
    return formattedString;
  }
}