import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:wasteagram/models/post.dart';


class NewEntryScreen extends StatefulWidget {
  @override
  State createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {

  LocationData? locationData;
  int? quantity;
  XFile? image;
  final picker = ImagePicker();
  String? url;
  bool photoSelected = false;

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
  }

  void getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    image = XFile(pickedFile!.path);
    photoSelected = true;
    setState(() {});
  }

  void getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    image = XFile(pickedFile!.path);
    photoSelected = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    if (!photoSelected) {
      return Scaffold(
          appBar: AppBar(
            leading: Semantics(child: IconButton(onPressed: () { Navigator.of(context).pop(); }, icon: const Icon(Icons.arrow_back)), button: true, enabled: true, onTapHint: 'Back',),
            title: Text("Wasteagram"),
            centerTitle: true,
          ),
          body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(onPressed: () {getImageFromCamera();}, child: Text('Take a new photo')),
            ElevatedButton(onPressed: () {getImageFromGallery();}, child: Text('Select from gallery'))
          ],))
      );
    }

    if (image == null) {
      return Scaffold(
          appBar: AppBar(
            leading: Semantics(child: IconButton(onPressed: () { Navigator.of(context).pop(); }, icon: const Icon(Icons.arrow_back)), button: true, enabled: true, onTapHint: 'Back',),
            title: Text("Wasteagram"),
            centerTitle: true,
          ),
          body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height: 10), Text('processing image...')],))
      );
    }
    return Scaffold(
        appBar: AppBar(
          leading: Semantics(child: IconButton(onPressed: () { Navigator.of(context).pop(); }, icon: const Icon(Icons.arrow_back)), button: true, enabled: true, onTapHint: 'Back',),
          title: Text("Wasteagram"),
          centerTitle: true,
        ),
        body: Column(children: [
          SizedBox(height: 20),
          Image.file(File(image!.path), height: 250),
          SizedBox(height: 20),
          Padding(padding: EdgeInsets.all(10), child:
            TextField(decoration: InputDecoration(border: UnderlineInputBorder(), labelText: 'Number of Wasted Items'), keyboardType: TextInputType.number, textAlign: TextAlign.center, onChanged: (value) { if (value == "") quantity = 0;else quantity = BigInt.parse(value).toInt(); }),
          ),
          Expanded(child: Center()),
          Semantics(
            child: ElevatedButton(
                child: Padding(padding: EdgeInsets.fromLTRB(50, 0, 50, 0), child: Icon(Icons.cloud_upload)),
                onPressed: () async {
                  if (quantity == null || quantity! <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ERROR:\nnumber of wasted items must be greater than zero')));
                  }
                  else {
                    Reference storageReference = FirebaseStorage.instance.ref()
                        .child('${DateTime.now().toString()}${image!.path}');
                    await storageReference.putFile(File(image!.path));
                    url = await storageReference.getDownloadURL();
                    Post post = Post(
                        date: DateTime.now(),
                        imageURL: url!,
                        quantity: quantity!,
                        latitude: locationData!.latitude!,
                        longitude: locationData!.longitude!);

                    FirebaseFirestore.instance.collection('posts').add({
                      'date': Timestamp((post.date.millisecondsSinceEpoch / 1000).round(), 0),
                      'imageURL': post.imageURL,
                      'quantity': post.quantity,
                      'latitude': post.latitude,
                      'longitude': post.longitude
                    });
                    Navigator.of(context).pop();
                  }
                }
            ),
            button: true,
            enabled: true,
            onTapHint: 'Upload post',
          ),
        ],)
    );
  }
}