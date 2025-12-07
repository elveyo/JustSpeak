import 'package:frontend/models/certificate.dart';
import 'package:frontend/providers/base_provider.dart';

class CertificateProvider extends BaseProvider<Certificate> {
  CertificateProvider() : super("Certificate");

  @override
  Certificate fromJson(dynamic json) {
    return Certificate.fromJson(json);
  }
}
