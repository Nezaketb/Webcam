import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
// import 'package:firebase_core/firebase_core.dart';
import 'package:realm/realm.dart';

import 'Entities/Files.dart';
// import 'firebase_options.dart';
// import 'package:firebase_storage/firebase_storage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  //   name: 'webcamera',
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webcam',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
Io.File? imageFile;
class GetImagesFromDb{
  Io.File getFiles() {
    var config = Configuration([Files.schema], readOnly: false, inMemory: false);
    var realm = Realm(config);
    var FileList =  realm.all<Files>();

    List<Io.File> ImageList = <Io.File>[];
    FileList.forEach((element) {
      Uint8List rawPath = base64Decode(element.Photo.toString());
      ImageList.add(
        Io.File.fromRawPath(rawPath)
      );
    });
    Uint8List rawPath = base64Decode(FileList.first.Photo.toString());
    return Io.File.fromRawPath(rawPath);
  }
}
class _MyHomePageState extends State<MyHomePage> {

  void _openCamera() async {
    var picture=await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile =Io.File(picture!.path);
    });
    var config = Configuration([Files.schema], readOnly: false, inMemory: false);
    var realm = Realm(config);
    List<int> imageBytes = imageFile?.readAsBytesSync() as List<int>;
    String img64 = base64Encode(imageBytes);
    String? ExtensionFile = ".jgp";
    String? MimeTypeFile   = picture?.mimeType.toString();
    var ImageData = Files(img64, Extension: ExtensionFile, MimeType: MimeTypeFile );
     realm.write(() {
       realm.add(ImageData);
     });
    // Reference ref=FirebaseStorage.instance.ref().child("user").child("image").child("image.png");
    // UploadTask uploadTask= ref.putFile(imageFile!);
  }
  void _opengallery() async {
    var picture=await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile =Io.File(picture!.path);
    });
    var config = Configuration([Files.schema], readOnly: false, inMemory: false);
    var realm = Realm(config);
    List<int> imageBytes = imageFile?.readAsBytesSync() as List<int>;
    String img64 = base64Encode(imageBytes);
    String? ExtensionFile = ".jgp";
    String? MimeTypeFile   = picture?.mimeType.toString();
    var ImageData = Files(img64, Extension: ExtensionFile, MimeType: MimeTypeFile );
    realm.write(() {
      realm.add(ImageData);
    });
    // Reference ref=FirebaseStorage.instance.ref().child("user").child("image").child("image.png");
    // UploadTask uploadTask= ref.putFile(imageFile!);
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(
          "Dosya Yükleme İşlemleri", style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.green[900],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: _openCamera, child: Text("Kameradan Resim Yükleme"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.orange,
                ),),
              ElevatedButton(
                onPressed:_opengallery, child:Text("Galeriden Resim Yükleme"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.orange,
                ),),
          Expanded (
              child: imageFile == null ?
              Text("Fotoğraf Yok"): Image.file(imageFile!),
          )
            // child: imageFile==null?
            // Text("Resim Yok"): Image.file(imageFile!),)
            ],
          ),
        ),


      ),
    );
  }
  }
