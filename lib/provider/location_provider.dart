import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double? latitude;
  double? longitude;
  bool permissionAllowed = false;
  // ignore: prefer_typing_uninitialized_variables
  var selectedAdressName;
  // ignore: prefer_typing_uninitialized_variables
  var selectedAdressAdress;
  // ignore: prefer_typing_uninitialized_variables
  var selectedSubArea;
  // ignore: prefer_typing_uninitialized_variables
  var selectedArea;
  // ignore: prefer_typing_uninitialized_variables
  var selectedAdressAll;
  bool loading = false;
  Future<Position> getCurrentPostion() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // ignore: unnecessary_null_comparison
    if (position != null) {
      latitude = position.latitude;
      longitude = position.longitude;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude!, longitude!);
      selectedAdressName = placemarks.first.name ?? '';
      selectedAdressAdress = placemarks.first.street ?? '';
      selectedArea = placemarks.first.administrativeArea;
      selectedSubArea = placemarks.first.subAdministrativeArea;
      selectedAdressAll = placemarks.first;
      permissionAllowed = true;
      notifyListeners();
    } else {}
    return position;
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    latitude = cameraPosition.target.latitude;
    longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude!, longitude!);
    selectedAdressName = placemarks.first.name ?? '';
    selectedAdressAdress = placemarks.first.street;
    selectedArea = placemarks.first.administrativeArea;
    selectedSubArea = placemarks.first.subAdministrativeArea;
    selectedAdressAll = '$selectedAdressAdress $selectedSubArea $selectedArea';
  }

  Future<void> savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('vido', latitude!);
    prefs.setDouble('kinhdo', longitude!);
    prefs.setString('diachi', selectedAdressAll!);
    prefs.setString('sonha', selectedAdressAdress!);
  }
}
