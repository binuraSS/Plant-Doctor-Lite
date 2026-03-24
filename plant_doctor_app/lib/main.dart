import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + Python Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter + Python Integration'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _pythonMessage = "Waiting for Python...";
  bool _isLoading = false;

  // Use this URL for Android emulator: http://10.0.2.2:5000
  // Use this URL for iOS simulator or web: http://localhost:5000
  // If using physical device, use your computer's IP address
 final String baseUrl = 'http://127.0.0.1:5000';

  @override
  void initState() {
    super.initState();
    _fetchMessageFromPython();
  }

  // Fetch initial message from Python
  Future<void> _fetchMessageFromPython() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/message'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _pythonMessage = data['message'];
          _counter = data['counter_value'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _pythonMessage = 'Error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _pythonMessage = 'Connection error: Make sure Python server is running';
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  // Increment counter via Python
  Future<void> _incrementCounterViaPython() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/increment/$_counter'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _counter = data['new_counter'];
          _pythonMessage = data['message'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _pythonMessage = 'Connection error: Make sure Python server is running';
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Python message section
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple),
              ),
              child: Column(
                children: [
                  Text(
                    'Python Backend Says:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    Text(
                      _pythonMessage,
                      style: TextStyle(fontSize: 16, color: Colors.purple[800]),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Counter section
            const Text('Counter value from Python:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _incrementCounterViaPython,
                  child: Text('Increment via Python'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isLoading ? null : _fetchMessageFromPython,
                  child: Text('Refresh Message'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _incrementCounterViaPython,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}