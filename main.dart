import 'dart:typed_data';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'pdf.dart';

void main() async {
  final PdfGenerator pdfGenerator = PdfGenerator();
  final app = Router();

  // Route POST pour recevoir des données
  app.post('/generate_pdf', (shelf.Request request) async {
    // Récupérer les données POST du corps de la requête
    String requestBody = await request.readAsString();

    // Convertir les données en un objet, par exemple JSON
    // Vous pouvez choisir le format de données que vous attendez
    // Ici, nous supposons que les données sont au format JSON
    Map<String, dynamic> requestData = Uri.splitQueryString(requestBody);

    // Utilisez les données pour personnaliser la génération du PDF
    // par exemple, en ajoutant le texte des données dans le PDF
    final Uint8List pdfBytes = await pdfGenerator.generatePDF(requestData);

    return shelf.Response.ok(pdfBytes, headers: {'Content-Type': 'application/pdf'});
  });

  final handler = const shelf.Pipeline().addMiddleware(shelf.logRequests()).addHandler(app);

  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Server started on port 8080');
  print('GET endpoint: http://${server.address.host}:${server.port}/generate_pdf');
  print('POST endpoint: http://${server.address.host}:${server.port}/generate_pdf (for receiving data)');
}