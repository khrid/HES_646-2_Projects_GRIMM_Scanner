import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRUtils {
  /// Renvoie un Widget QrImage avec le paramètre [text] encodé dans un QR code
  static Widget generateQrWidgetFromString(String text) {
    return QrImage(
      data: text,
      // le texte à encoder dans un QR code
      version: QrVersions.auto,
      // la version du QR (+ de texte => version + haute)
      size: 150.0,
      // la taille
      errorStateBuilder: (cxt, err) {
        // en cas d'erreur de génération
        return const Center(
          child: Text(
            "🐛 Erreur lors de le génération du code QR 🐛",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0),
          ),
        );
      },
    );
  }
}
