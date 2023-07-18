import 'dart:io';

import 'package:csvwriter/csvwriter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    String filename = 'number_props';
    String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Your File to desired location',
        fileName: filename);
    if(outputFile == null){
      return;
    }
    var numbersFile = File('$outputFile.csv');
    var numbersCsv =
        CsvWriter.withHeaders(numbersFile.openWrite(), FlowLogData.names);

    try {
      for (var i = 0; i < 100; i++) {
        String date = DateFormat('yyyy-MM-ddThh:mm:ssZ').format(DateTime.now());
        final flowLogData = FlowLogData(
          timestamp: date,
          flow: i * 1.5,
          power: i * 0.8,
          tempHot: i * 2.5,
          tempCold: i * 1.7,
        );
        numbersCsv.writeData(data: flowLogData.toMap());
      }
    } finally {
      await numbersCsv.close();
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FlowLogData {
  String timestamp;
  double flow;
  double power;
  double tempHot;
  double tempCold;

  FlowLogData({
    required this.timestamp,
    required this.flow,
    required this.power,
    required this.tempHot,
    required this.tempCold,
  });

  Map<String, dynamic> toMap() {
    return {
      names[0]: timestamp,
      names[1]: flow,
      names[2]: power,
      names[3]: tempHot,
      names[4]: tempCold,
    };
  }

  static List<String> get names => [
        'Timestamp',
        'Flow',
        'Power',
        'Temp Hot',
        'Temp Cold',
      ];
}
