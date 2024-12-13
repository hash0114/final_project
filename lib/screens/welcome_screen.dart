import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:final_project/utils/app_state.dart';
import 'package:final_project/screens/joinScreen.dart';
import 'package:final_project/screens/createScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Night'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text(
                  'Start Session',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JoinScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text(
                  'Enter Code',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeDeviceId() async {
    String deviceId = await _fetchDeviceId();
    if (mounted) {
      // Check if widget is still mounted
      Provider.of<AppState>(context, listen: false).setDeviceId(deviceId);
    }
  }

  Future<String> _fetchDeviceId() async {
    String deviceId = "";

    try {
      if (Platform.isAndroid) {
        const androidPlugin = AndroidId();
        deviceId = await androidPlugin.getId() ?? 'Unknown id';
      } else if (Platform.isIOS) {
        var deviceInfoPlugin = DeviceInfoPlugin();
        var iOSInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iOSInfo.identifierForVendor ?? 'Unknown id';
      } else {
        deviceId = 'Unsupported platform';
      }
    } catch (e) {
      deviceId = 'Error: $e';
    }

    return deviceId;
  }
}
