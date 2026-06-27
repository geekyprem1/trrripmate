import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Captures a receipt photo and caches it locally before upload (Architecture
/// §10). Downscale + compression are handled by the picker (≤1600px, q70) so
/// uploads stay small; the file is copied into app storage so it survives.
class ReceiptCaptureService {
  ReceiptCaptureService([ImagePicker? picker])
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Picks an image from [source], returning the cached local path or `null`
  /// if the user cancelled.
  Future<String?> capture(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 70,
    );
    if (picked == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final receiptsDir = Directory(p.join(dir.path, 'receipts'));
    await receiptsDir.create(recursive: true);
    final target = p.join(
      receiptsDir.path,
      '${DateTime.now().microsecondsSinceEpoch}${p.extension(picked.path)}',
    );
    await File(picked.path).copy(target);
    return target;
  }
}
