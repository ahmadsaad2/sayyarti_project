import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sayyarti/Screens/home/home.dart';
import 'package:sayyarti/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagePick extends StatefulWidget {
  const ImagePick({super.key});

  @override
  State<ImagePick> createState() {
    return _ImagePickState();
  }
}

class _ImagePickState extends State<ImagePick> {
  File? _image;
  final ImagePicker picker = ImagePicker();
  bool granted = false;
  bool isUploading = false;
  var imageUrl = '';

  void _pickImage() async {
    if (!granted) {
      return;
    }
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _image = File(imageFile.path);
    });
  }

  void _takePicture() async {
    if (!granted) {
      return;
    }
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _image = File(imageFile.path);
    });
  }

  void _verify() async {
    if (_image == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('No Image Selected'),
              content: const Text(
                  'Please pick an image or take to verify your account'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          });
    }
    setState(() {
      isUploading = true;
    });
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dwhjtcbx7/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'trusted'
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path));
    final res = await request.send();
    if (res.statusCode == 200) {
      final responseData = await res.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      imageUrl = jsonMap['url'];
      print(imageUrl);
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('id');
      final url = Uri.http(backendUrl, '/user/info-update/$userId');
      final backRes = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': prefs.getString('token')!,
        },
        body: json.encode({
          'img_uri': imageUrl,
          'verify_stat': 'pending',
        }),
      );
      if (backRes.statusCode == 200) {
        setState(() {
          isUploading = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Verification'),
                content: const Text(
                    'Your account is under verification, please wait for the admin to approve it.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
      } else {
        setState(() {
          isUploading = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content:
                    const Text('An error occurred, please try again later.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkCameraPermission();
  }

  void checkCameraPermission() async {
    if (await Permission.camera.isGranted) {
      setState(() {
        granted = true;
      });
    }
    PermissionStatus status = await Permission.camera.request();
    setState(() {
      granted = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image != null
              ? Image.file(
                  _image!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                )
              : const Text('No Image Selected'),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    _pickImage();
                  },
                  label: const Text('Upload Image'),
                  icon: const Icon(Icons.upload),
                ),
                const SizedBox(width: 18),
                TextButton.icon(
                  onPressed: granted
                      ? _takePicture
                      : () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Permission'),
                                  content: const Text(
                                      'To use the camera, please allow camera access.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await Permission.camera.request();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              });
                        },
                  label: const Text('Take a Picture'),
                  icon: const Icon(Icons.camera_alt),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _verify();
              },
              child: isUploading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Verify'),
            ),
          ),
        ],
      ),
    );
  }
}
