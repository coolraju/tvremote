import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(SonyTvRemoteApp());
}

class SonyTvRemoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RemoteControlPage(),
    );
  }
}

class RemoteControlPage extends StatefulWidget {
  @override
  _RemoteControlPageState createState() => _RemoteControlPageState();
}

class _RemoteControlPageState extends State<RemoteControlPage> {
  String tvIp = '192.168.1.2'; // Replace with your TV's IP address
  TextEditingController ipController = TextEditingController();
  void sendCommand(String command) async {
    try {
      //wait popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Sending command...'),
              ],
            ),
          );
        },
      );
      tvIp = ipController.text;
      final url = Uri.http(tvIp, '/sony/IRCC');
      print(url);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/xml',
          'SOAPACTION': '"urn:schemas-sony-com:service:IRCC:1#X_SendIRCC"',
        },
        body: '''
      <?xml version="1.0"?>
      <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
        <s:Body>
          <u:X_SendIRCC xmlns:u="urn:schemas-sony-com:service:IRCC:1">
            <IRCCCode>$command</IRCCCode>
          </u:X_SendIRCC>
        </s:Body>
      </s:Envelope>
      ''',
      ).timeout(const Duration(seconds: 30));
      print(response.statusCode);

      if (response.statusCode == 200) {
        //dialog close
        Navigator.pop(context);
        // show close dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Command sent successfully'),
            );
          },
        );
        print('Command sent successfully');
      } else {
        //dialog close
        Navigator.pop(context);
        // show close dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Failed to send command'),
            );
          },
        );
        print('Failed to send command');
      }
    } catch (e) {
      //dialog close
      Navigator.pop(context);
      // show close dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Failed to send command' + e.toString()),
          );
        },
      );
      print('Failed to send command');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sony TV Remote'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //text field for ip
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  child: TextField(
                    controller: ipController,
                    decoration: InputDecoration(
                      hintText: 'Enter TV IP Address Here',
                      //line border
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      //update ip address
                      // tvIp = value;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      sendCommand('AAAAAQAAAAEAAAAVAw=='), // Power command
                  child: Text('Power'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      sendCommand('AAAAAQAAAAEAAAATAw=='), // Volume Up command
                  child: Text('Volume Up'),
                ),
                ElevatedButton(
                  onPressed: () => sendCommand(
                      'AAAAAQAAAAEAAAATAw=='), // Volume Down command
                  child: Text('Volume Down'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      sendCommand('AAAAAQAAAAEAAAAUAw=='), // Mute command
                  child: Text('Mute'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      sendCommand('AAAAAQAAAAEAAAAVAw=='), // Input command
                  child: Text('Input'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      sendCommand('AAAAAQAAAAEAAAAWAQ=='), // Home command
                  child: Text('Home'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      sendCommand('AAAAAQAAAAEAAAAAAw=='), // Up command
                  child: Text('Up'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      sendCommand('AAAAAQAAAAEAAAAAAw=='), // Left command
                  child: Text('Left'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      sendCommand('AAAAAQAAAAEAAAAFAw=='), // Enter command
                  child: Text('Enter'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      sendCommand('AAAAAQAAAAEAAAAAAw=='), // Right command
                  child: Text('Right'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAAVAw=='), // Power command
//               child: Text('Power'),
//             ),
//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAATAw=='), // Volume Up command
//               child: Text('Volume Up'),
//             ),
//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAATAw=='), // Volume Down command
//               child: Text('Volume Down'),
//             ),
//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAAUAw=='), // Mute command
//               child: Text('Mute'),
//             ),
//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAAVAw=='), // Channel Up command
//               child: Text('Channel Up'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAAWAw=='), // Channel Down command
//               child: Text('Channel Down'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAAjAw=='), // Input command
//               child: Text('Input'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA9Aw=='), // Home command
//               child: Text('Home'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAAzAw=='), // Guide command
//               child: Text('Guide'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA0Aw=='), // Info command
//               child: Text('Info'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA7Aw=='), // Options command
//               child: Text('Options'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA6Aw=='), // Return command
//               child: Text('Return'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA8Aw=='), // Exit command
//               child: Text('Exit'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA4Aw=='), // Up command
//               child: Text('Up'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAAsAw=='), // Down command
//               child: Text('Down'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAArgw=='), // Left command
//               child: Text('Left'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAAsgw=='), // Right command
//               child: Text('Right'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA1Aw=='), // Confirm command
//               child: Text('Confirm'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAAzAw=='), // Red command
//               child: Text('Red'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA0Aw=='), // Green command
//               child: Text('Green'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA1Aw=='), // Yellow command
//               child: Text('Yellow'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA2Aw=='), // Blue command
//               child: Text('Blue'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAAzAw=='), // Play command
//               child: Text('Play'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA0Aw=='), // Pause command
//               child: Text('Pause'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA1Aw=='), // Stop command
//               child: Text('Stop'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA2Aw=='), // Rewind command
//               child: Text('Rewind'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA3Aw=='), // Forward command
//               child: Text('Forward'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA4Aw=='), // Previous command
//               child: Text('Previous'),
//             ),

//             ElevatedButton(
//               onPressed: () =>
//                   sendCommand('AAAAAQAAAAEAAAA5Aw=='), // Next command
//               child: Text('Next'),
//             ),
