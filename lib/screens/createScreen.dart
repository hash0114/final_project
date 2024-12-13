import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project/utils/app_state.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:final_project/screens/movieScreen.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  String code = "Unset";

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Share Code',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Container(
          color: Colors.blue[200],
          child: Center(
            child: Column(
              children: [
                Spacer(),
                Text(
                  code,
                  style: TextStyle(
                    fontSize: 42,
                  ),
                ),
                SizedBox(height: 20),
                Text('Share this code with your friend'),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MovieCodeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.white,
                    backgroundColor: Colors.blue,
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  label: Text(
                    'Begin',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ));
  }

  Future<void> _startSession() async {
    String? deviceId = Provider.of<AppState>(context, listen: false).deviceId;

    final prefs = await SharedPreferences.getInstance();

    //call api
    final response = await HttpHelper.startSession(deviceId);

    prefs.setString("sessionId", response['data']['session_id']);
    setState(() {
      code = response['data']['code'];
    });
  }
}
