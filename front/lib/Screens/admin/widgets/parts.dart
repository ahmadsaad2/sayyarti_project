import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sayyarti/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() {
    return _AddProductState();
  }
}

class _AddProductState extends State<AddProduct> {
  // final List<String> _brandNames = [];
  List<String> _selectedItems = [];
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker picker = ImagePicker();
  bool granted = false;
  bool isUploading = false;
  String? _partName;
  String? _description;
  double? _price;
  String? _imageUrl;
  final List<String> _categories = <String>[
    'Spare Parts',
    'Battery',
    'Wheels',
    'Accessories',
    'Maintenance',
  ];
  String? _selectedCategory;

  var _saving = false;

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

  void _getBrands() async {
    final url = Uri.http(backendUrl, '/user/get-brands/');
    final res = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    Map<String, dynamic> data = jsonDecode(res.body);
    List<dynamic> brands = data['brand'];
    List<String> brandNames = [];
    for (var brand in brands) {
      brandNames.add(brand['brand']);
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    if (_image == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('No Image Selected'),
              content: const Text('Please pick an image or take on '),
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
      _saving = true;
    });
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dwhjtcbx7/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'trusted'
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      _imageUrl = jsonMap['url'];
      print(_imageUrl);
      final prefs = await SharedPreferences.getInstance();
      final url = Uri.http(backendUrl, '/admin/part');
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': prefs.getString('token')!,
        },
        body: json.encode({
          'part_name': _partName,
          'compatible_cars': _selectedItems,
          'description': _description,
          'price': _price,
          'image_url': _imageUrl,
          'category': _selectedCategory,
        }),
      );
      if (res.statusCode != 201) {
        setState(() {
          _saving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('field to add a product please try again later'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    setState(() {
      _saving = false;
    });
  }

  @override
  void initState() {
    _getBrands();
    checkCameraPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Part to Shop',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 49, 87, 194),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
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
                const SizedBox(height: 20),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    counterText: '',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(FontAwesomeIcons.gears),
                    ),
                    labelText: 'Part Name',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 6) {
                      return 'Please enter the detailed part name';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _partName = newValue!;
                  },
                ),
                const SizedBox(height: 20),
                DropdownSearch<String>.multiSelection(
                  //
                  items: (filter, loadProps) async {
                    final url = Uri.http(backendUrl, '/user/get-brands/');
                    final res = await http.get(
                      url,
                      headers: {
                        'Content-Type': 'application/json',
                      },
                    );
                    if (res.statusCode == 200) {
                      Map<String, dynamic> data = jsonDecode(res.body);
                      List<dynamic> brands = data['brand'];
                      List<String> _brandNames = [];
                      for (var brand in brands) {
                        _brandNames.add(brand['brand']);
                      }
                      return _brandNames;
                    } else {
                      // Return an empty list if the request fails
                      return [];
                    }
                  },
                  selectedItems: _selectedItems,
                  onChanged: (List<String> selectedItems) {
                    setState(() {
                      _selectedItems = selectedItems; // Update selected items
                    });
                  },
                  dropdownBuilder: (context, selectedItems) {
                    return Text(
                      selectedItems.isEmpty
                          ? '' //comeback here
                          : selectedItems.join(', '),
                      style: TextStyle(fontSize: 16),
                    );
                  },
                  popupProps: PopupPropsMultiSelection.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // Customize the appearance of selected items in the popup
                    itemBuilder: (context, item, isSelected, onTap) {
                      return ListTile(
                        title: Text(item),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: Colors.blue)
                            : null,
                      );
                    },
                  ),
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: 'compatible cars',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.directions_car),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Catrgory',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.list),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (val) {
                      setState(() {
                        _selectedCategory = val;
                      });
                    },
                    items: _categories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(),
                  maxLength: 50,
                  decoration: const InputDecoration(
                    counterText: '',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.attach_money),
                    ),
                    labelText: 'Price',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 6) {
                      return '';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _price = double.tryParse(newValue!);
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Part Description',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the description of the part';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _description = val;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      _save();
                    },
                    child: _saving
                        ? const CircularProgressIndicator()
                        : const Text('ADD Part'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
