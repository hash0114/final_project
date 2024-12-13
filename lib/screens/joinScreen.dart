import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:final_project/screens/movieScreen.dart';
import 'package:final_project/utils/app_state.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final myController = TextEditingController();
  bool isInvalid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter Code',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue[200],
        child: Center(
          child: isInvalid
              ? AlertDialog(
                  title: Text('No Session Found'),
                  content: Text('Please enter a valid code'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isInvalid = false;
                          myController.text = "";
                        });
                      },
                      child: Text('OK'),
                    )
                  ],
                )
              : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 36,
                      ),
                      maxLength: 4,
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: myController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter the code from your friend',
                        labelStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      await _joinSession(int.parse(myController.text));
                      if (!isInvalid && mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MovieCodeScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                      backgroundColor: Colors.blue,
                      iconColor: Colors.white,
                      textStyle: TextStyle(fontSize: 20),
                    ),
                    iconAlignment: IconAlignment.start,
                    label: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Spacer(),
                ]),
        ),
      ),
    );
  }

  Future<void> _joinSession(code) async {
    String? deviceId = Provider.of<AppState>(context, listen: false).deviceId;
    final prefs = await SharedPreferences.getInstance();
    //call api
    final response = await HttpHelper.joinSession(deviceId, code);

    if (response['data'] != null) {
      await prefs.setString("sessionId", response['data']['session_id']);
      setState(() {
        isInvalid = false;
      });
    } else {
      setState(() {
        isInvalid = true;
      });
    }
  }
}
