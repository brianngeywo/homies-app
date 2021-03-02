import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homie_app/pages/home.dart';
import 'package:homie_app/widgets/progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

class Upload extends StatefulWidget {
  final GoogleSignInAccount currentUser = googleSignIn.currentUser;
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload>
    with AutomaticKeepAliveClientMixin<Upload> {
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  TextEditingController bedroomController = TextEditingController();
  TextEditingController parkingController = TextEditingController();
  TextEditingController bathroomController = TextEditingController();
  TextEditingController internetController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController placeDescriptionController = TextEditingController();
  TextEditingController locationDescriptionController = TextEditingController();
  var geoLocator = Geolocator();
  String fileUrl;
  String postId = Uuid().v4();
  bool isUploading = false;
  File pickedFile;
  final picker = ImagePicker();
  handleTakePhoto() async {
    Navigator.pop(context);
    final file = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      if (file != null) {
        pickedFile = File(file.path);
      } else {
        print("no image selected");
      }
    });
  }

  handlePickFromGallery() async {
    Navigator.pop(context);
    final file = await picker.getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (file != null) {
        pickedFile = File(file.path);
      } else {
        print("no image selected");
      }
    });
  }

  selectImage(parentcontext) {
    return showDialog(
      context: parentcontext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: [
            SimpleDialogOption(
                child: Text("Photo with camera"), onPressed: handleTakePhoto),
            SimpleDialogOption(
              child: Text("Photo with gallery"),
              onPressed: handlePickFromGallery,
            ),
            SimpleDialogOption(
                child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
          ],
        );
      },
    );
  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/upload.svg",
            height: 260.9,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () => selectImage(context),
              child: Text(
                "upload rental listing",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      pickedFile = null;
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    fileUrl = await uploadImage(pickedFile);
    createPostInFirestore(
      mediaUrl: fileUrl,
      location: locationController.text,
      description: captionController.text,
      bedrooms: bedroomController.text,
      parking: parkingController.text,
      bathrooms: bathroomController.text,
      internet: internetController.text,
      rent: rentController.text,
      phone: phoneController.text,
      locationDescription: locationDescriptionController.text,
placeDescription:placeDescriptionController.text,
    );
    captionController.clear();
    locationController.clear();
    bedroomController.clear();
    parkingController.clear();
    bathroomController.clear();
    internetController.clear();
    rentController.clear();
    phoneController.clear();
    locationDescriptionController.clear();
    placeDescriptionController.clear();
    setState(() {
      pickedFile = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask storageUplaodTask =
        storageRef.child("post_$postId.jpg").putFile(imageFile);
    String downloadUrl = await (await storageUplaodTask).ref.getDownloadURL();
    return downloadUrl;
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(pickedFile.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(
          imageFile,
          quality: 75,
        ),
      );
    setState(() {
      pickedFile = compressedImageFile;
    });
  }

  createPostInFirestore({
    String mediaUrl,
    String location,
    String description,
    String bedrooms,
    String parking,
    String bathrooms,
    String internet,
    String rent,
    String phone,
    String locationDescription,
    String placeDescription,
  }) {
    postsRef
        .doc(widget.currentUser.id)
        .collection("userPosts")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": widget.currentUser.id,
      "medialUrl": mediaUrl,
      "location": location,
      "description": description,
      "timestamp": timestamp,
      "display name": widget.currentUser.displayName,
      "bedrooms": bedrooms,
      "parking": parking,
      "bathrooms": bathrooms,
      "internet": internet,
      "rent": rent,
      "phone": phone,
      "place description": placeDescription,
      "location description": locationDescription,
    });
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String name = placemark.name;
    // String subLocality = placemark.subLocality;
    String locality = placemark.locality;
    // String administrativeArea = placemark.administrativeArea;
    // String postalCode = placemark.postalCode;
    String country = placemark.country;
    String address = name + ', ' + locality + ', ' + country;
    print(address);
    locationController.text = address;
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: clearImage),
          title: Text(
            "CaptionPost",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: isUploading == true ? null : () => handleSubmit(),
              child: Text(
                "Post",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ]),
      body: ListView(
        children: [
          isUploading ? linearProgress() : Text(""),
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(pickedFile),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.teal[700],
              size: 35,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: "property name",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.attach_money,
              color: Colors.teal[700],
              size: 35,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: rentController,
                decoration: InputDecoration(
                  hintText: "rent per month e.g 23,000",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.king_bed,
              color: Colors.teal[700],
              size: 35,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: bedroomController,
                decoration: InputDecoration(
                  hintText: "bedrooms",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.bathtub,
              color: Colors.teal[700],
              size: 35,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: bathroomController,
                decoration: InputDecoration(
                  hintText: "bathrooms",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.directions_car,
              color: Colors.teal[700],
              size: 35,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: parkingController,
                decoration: InputDecoration(
                  hintText: "is parking available? yes/no",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.wifi,
              color: Colors.teal[700],
              size: 35,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: internetController,
                decoration: InputDecoration(
                  hintText: "is wifi provided? yes/no",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.phone,
              color: Colors.teal[700],
              size: 35,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: "phone number to call for booking",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.directions,
              color: Colors.teal[700],
              size: 35,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: locationDescriptionController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: "direction e.g opposite naivas supermarket",
                  // border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(top: 10),
            color: Colors.grey[200],
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.pin_drop,
                    color: Colors.teal[700],
                    size: 35,
                  ),
                  title: Container(
                    width: 250,
                    child: TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: "Apartment location",
                        // border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Divider(),
                Container(
                  width: 200,
                  height: 100,
                  alignment: Alignment.center,
                  color: Colors.grey[200],
                  child: ElevatedButton.icon(
                    onPressed: () => getUserLocation(),
                    icon: Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Use Current Location",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return pickedFile == null ? buildSplashScreen() : buildUploadForm();
  }
}
