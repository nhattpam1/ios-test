import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare/landingpage.dart';
import 'package:petcare/petprofile2.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';



class petprofile extends StatefulWidget {
  const petprofile({super.key});

  @override
  State<petprofile> createState() => _petprofileState();
}

class _petprofileState extends State<petprofile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;
  bool isMaleSelected = false;
  bool isFemaleSelected = false;
  bool isCatSelected = false;
  bool isDogeSelected = false;

  String _imagePath = "";


  // Define form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  //create pet form get data
  TextEditingController _imageProfileController = TextEditingController();
  TextEditingController _petNameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _petTypeController = TextEditingController();
  TextEditingController _breedController = TextEditingController();


  //create pet function
  Future<void> _createPet() async {
    final imageProfile = _imagePath;
    final petName = _petNameController.text;
    final gender = isMaleSelected ? true : false;
    final petType = isDogeSelected ? 'Dog' : 'Cat';
    final breed = _breedController.text;

    try {
      // Pet created successfully, navigate to petprofile2
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => petprofile2(
            imageProfile: imageProfile,
            petName: petName,
            gender: isMaleSelected ? true : false,
            petType: isDogeSelected ? 'Dog' : 'Cat',
            breed: _breedController.text,
            // Pass other data as needed
          ),
        ),
      );
    } catch (e) {
      // Handle any errors that occur during pet creation
      print('Error creating pet: $e');
      // You can show an error message to the user if needed.
    }
  }


  //pick image from device
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path; // Update the image path
      });
      await uploadImageToFirebaseStorage(File(pickedFile.path));
    }
  }

  //upload to firebase
  Future<void> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final uuid = Uuid();
      final String fileName = '${uuid.v4()}.jpg';

      // Get a reference to the Firebase Storage bucket
      final Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');

      // Upload the file to Firebase Storage
      final UploadTask uploadTask = storageReference.putFile(imageFile);

      // Wait for the upload to complete and get the download URL
      await uploadTask.whenComplete(() => null);

      // Get the download URL
      final String imageUrl = await storageReference.getDownloadURL();

      //gan imageProfile
      _imagePath = imageUrl;

      // Now you can use imageUrl to display or store the uploaded image
      print('Image uploaded to Firebase Storage: $imageUrl');
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF9F1EF),
        title: Text(
          'Pet Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              isClicked = !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
            });
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => landingpage(),
            ));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '1',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: ' of 2',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 285,
                height: 11,
                child: Stack(
                  children: [
                    Positioned(
                      left: 1,
                      top: 1,
                      child: Container(
                        width: 284,
                        height: 10,
                        decoration: ShapeDecoration(
                          color: Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 142,
                        height: 10,
                        decoration: ShapeDecoration(
                          color: Color(0xFFFFBD58),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 131.48,
                  height: 119.63,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 131.48,
                          height: 119.63,
                          decoration: ShapeDecoration(
                            color: Color(0xFFF6F6F6),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Color(0xFFE7E7E7)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      if (_imagePath != null)
                        Container(
                          width: 131.48,
                          height: 119.63,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: FileImage(File(_imagePath!)),
                              fit: BoxFit.fill,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        )
                      else
                        Center(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0), // Điều chỉnh giá trị left tùy ý
                  child: Text(
                    'Pet Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: '',
                    filled: true,
                    fillColor: Color(0xFFD9D9D9),
                    labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    enabledBorder: OutlineInputBorder(
                      // Độ to và màu sắc của viền khi trường chưa được chọn
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  controller: _petNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    // You can add additional email format validation here if needed
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0), // Điều chỉnh giá trị left tùy ý
                  child: Text(
                    'Pet Gender',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMaleSelected = true;
                        isFemaleSelected = false;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.08,
                      color: isMaleSelected ? Color(0xFFFFBD58) : Colors.grey,
                      child: Center(
                        child: Text(
                          'Male',
                          style: TextStyle(
                            color: isMaleSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMaleSelected = false;
                        isFemaleSelected = true;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.08,
                      color: isFemaleSelected ? Color(0xFFFFBD58) : Colors.grey,
                      child: Center(
                        child: Text(
                          'Female',
                          style: TextStyle(
                            color:
                            isFemaleSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0), // Điều chỉnh giá trị left tùy ý
                  child: Text(
                    'Pet Type',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isDogeSelected = true;
                        isCatSelected = false;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.08,
                      color: isDogeSelected ? Color(0xFFFFBD58) : Colors.grey,
                      child: Center(
                        child: Text(
                          'Dog',
                          style: TextStyle(
                            color: isDogeSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isDogeSelected = false;
                        isCatSelected = true;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.08,
                      color: isCatSelected ? Color(0xFFFFBD58) : Colors.grey,
                      child: Center(
                        child: Text(
                          'Cat',
                          style: TextStyle(
                            color: isCatSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0), // Điều chỉnh giá trị left tùy ý
                  child: Text(
                    'Breed',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: '',
                    filled: true,
                    fillColor: Color(0xFFD9D9D9),
                    labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    enabledBorder: OutlineInputBorder(
                      // Độ to và màu sắc của viền khi trường chưa được chọn
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  controller: _breedController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Breed is required';
                    }
                    // You can add additional email format validation here if needed
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.1,
                child: ElevatedButton(
                  onPressed: () async {
                    await _createPet();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Adjust horizontal padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: isClicked ? Colors.black : Color(0xFFFFBD58),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: isClicked ? Colors.white : Colors.black,
                      fontSize: 18, // Adjust font size
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
