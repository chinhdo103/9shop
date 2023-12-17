import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_9shop/provider/location_provider.dart';
import 'package:project_9shop/screen/login_screen.dart';
import 'package:project_9shop/screen/main_screen.dart';
import 'package:project_9shop/provider/auth_provider.dart' as AuthProviderr;
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng currentLocation;
  GoogleMapController? _mapController;
  bool _locating = false;
  bool _loggedIn = false;
  User? user;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if (user != null) {
      setState(() {
        _loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProviderr.AuthProvider>(context);

    setState(() {
      currentLocation =
          LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);
    });
    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: currentLocation,
            zoom: 14.4746,
          ),
          zoomControlsEnabled: false,
          minMaxZoomPreference: const MinMaxZoomPreference(1.5, 20.8),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          mapToolbarEnabled: true,
          onCameraMove: (CameraPosition positon) {
            setState(() {
              _locating = true;
            });
            locationData.onCameraMove(positon);
          },
          onMapCreated: onCreated,
          onCameraIdle: () {
            setState(() {
              _locating = false;
            });
            locationData.getMoveCamera();
          },
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            height: 40,
            child: Image.asset('assets/images/location.png'),
          ),
        ),
        Center(
          child: SpinKitPulse(
            color: Colors.black54,
            size: 100.0,
          ),
        ),
        Positioned(
          bottom: 0.0,
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _locating
                    ? LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: TextButton.icon(
                    icon: Icon(
                      Icons.location_searching,
                      color: Theme.of(context).primaryColor,
                    ),
                    label: Text(
                        _locating
                            ? 'Đang cập nhật ... '
                            : locationData.selectedAdressAdress.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Colors.black)),
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                      _locating
                          ? 'Đang cập nhật ...'
                          : '${locationData.selectedSubArea.toString()},${locationData.selectedArea.toString()}',
                      style: const TextStyle(color: Colors.black54)),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: AbsorbPointer(
                      absorbing: _locating ? true : false,
                      child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: _locating
                                ? MaterialStateProperty.all<Color>(Colors.grey)
                                : MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          onPressed: () {
                            locationData.savePrefs();
                            if (_loggedIn == false) {
                              Navigator.pushNamed(context, LoginScreen.id);
                            } else {
                              print(user?.uid);
                              _auth.updateUser(
                                  id: user?.uid,
                                  sdt: user?.phoneNumber,
                                  latitude: locationData.latitude,
                                  longitude: locationData.longitude,
                                  address: locationData.selectedAdressAll
                                      .toString());
                              Navigator.pushNamed(context, MainScreen.id);
                            }
                          },
                          child: const Text(
                            'XÁC NHẬN VỊ TRÍ',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    )));
  }
}
