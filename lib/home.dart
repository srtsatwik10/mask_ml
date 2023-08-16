import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;
  late File _image;
  late List _output;
  final imagepicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  detectimage(File image) async {
    var prediction = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _output = prediction!;
      loading = false;
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    super.dispose();
  }

  pickimage_camera() async {
    var image = await imagepicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectimage(_image);
  }

  pickimage_gallery() async {
    var image = await imagepicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectimage(_image);
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        title: Text(
          'ML Classifier',
          style: GoogleFonts.roboto(),
        ),
      ),
      body:
       Container(
        
        height: h,
        width: w,
        child: Column(
          children: [
            Container(
              height: 150,
              width: 150,
              padding: EdgeInsets.all(10),
              child: Image.asset('assets/mask.png'),
            ),
            Container(
                child: Text('Mask Detector',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ))),
            SizedBox(height: 50),
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        style:ElevatedButton.styleFrom(backgroundColor: Colors.teal, 
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        child: Text('Capture',
                            style: GoogleFonts.roboto(fontSize: 18)),
                        onPressed: () {
                          pickimage_camera();
                        }),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal,  
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        child: Text('Gallery',
                            style: GoogleFonts.roboto(fontSize: 18)),
                        onPressed: () {
                          pickimage_gallery();
                        }),
                  ),
                  SizedBox(height: 20.0)
                ],
              ),
            ),
            loading != true
                ? Container(
                    child: Column(
                      children: [
                        Container(
                          height: 250,
                          width: 200,
                          padding: EdgeInsets.all(15),
                          child: Image.file(_image),
                        ),
                        // ignore: unnecessary_null_comparison
                        _output != null
                            ? Text(
                                (_output[0]['label']).toString().substring(2),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                                )
                            : Text(''),
                        // ignore: unnecessary_null_comparison
                        _output != null?
                             Text(
                                'Confidence: ' +
                                    (_output[0]['confidence']).toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ))
                            : Text('')
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
          