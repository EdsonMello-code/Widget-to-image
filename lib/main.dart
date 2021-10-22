// import 'dart:async';




import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// enum StatePage  {
//   start,
//   loading,
//   success
// }

class _MyHomePageState extends State<MyHomePage> {

  int _counter = 0;

  final GlobalKey genKey = GlobalKey();

  Future<void> takePicture() async {
    // state = StatePage.loading;
    //  setState(() {});
    
    final imageInMemory = await generateImageInMemory();
    await saveImageInStorage(imageInMemory);

    // setState(() {});
    
    // state = StatePage.success;
  }

  Future<Uint8List> generateImageInMemory() async {
    final RenderRepaintBoundary boundary = genKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();
    
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> saveImageInStorage(Uint8List imageInMemory) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = File('$directory/photo-${DateTime.now()}.png');
    
    await imgFile.writeAsBytes(imageInMemory); 
  }
  
  // StatePage state = StatePage.start; 

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    //  state = StatePage.start; 
    super.initState();
  }

  // Widget _buildStatePhotoPage(StatePage state) {
  //   switch (state) {
  //     case StatePage.loading:
  //       return const CircularProgressIndicator();
  //     case StatePage.success:
  //       return const Text('Taked Photo');
        
  //     default:
  //       return Container();
        
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: genKey,
      child: Scaffold(
        appBar: AppBar(
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
                style: Theme.of(context).textTheme.headline4,
              ),
              ElevatedButton(
                  onPressed: ()  async {
                    await takePicture();  
                    setState(() {});
                  },
                  child: const Text(
                    "Take Picture",
                  )),

                  // _buildStatePhotoPage(state)
            ],
          ),

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}