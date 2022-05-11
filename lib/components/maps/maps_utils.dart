import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double lat, double lon) async {
    final googleMapUrl = 
    Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lon");

    if (!await launchUrl(
      googleMapUrl,
      mode: LaunchMode.externalApplication
      )) throw 'Could not launch $googleMapUrl';
    
  }
}
