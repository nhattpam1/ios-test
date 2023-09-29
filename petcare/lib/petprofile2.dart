import 'package:flutter/material.dart';
import 'package:petcare/home.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:petcare/petprofile.dart';
import 'package:petcare/session-petcare/session.dart';

class petprofile2 extends StatefulWidget {
  final String imageProfile;
  final String  petName;
  final bool gender;
  final String petType;
  final String breed;

  const petprofile2({required this.imageProfile, required this.petName,
    required this.gender, required this.petType, required this.breed, Key? key}) : super(key: key);
  @override
  State<petprofile2> createState() => _petprofile2State();
}

class _petprofile2State extends State<petprofile2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;
  bool isWetFoodSelected = false;
  bool isDryFoodSelected = false;
  bool isMixSelected = false;
  DateTime? selectedDate; // Thêm biến để lưu trữ ngày sinh

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


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  //create pet form get data
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _currentDietController = TextEditingController();
  TextEditingController _noteController = TextEditingController();


  //create pet function
  Future<void> _createPet() async {
    final dateOfBirth = selectedDate != null ? selectedDate!.toIso8601String() : "";
    final weight = _weightController.text;
    final currentDiet = isWetFoodSelected
        ? 'Wet Food'
        : (isDryFoodSelected ? 'Dry Food' : (isMixSelected ? 'Mix' : ''));
    final note = _noteController.text;
    //try to get userId in session
    int? userId = SessionManager().userId;

    if (userId != null) {
      // You have the userId, you can use it here
      print('User ID trong session: $userId');
    } else {
      // User is not logged in or userId is not set
    }

    // Use the data received from the first page here
    final imageProfile = widget.imageProfile;
    final petName = widget.petName;
    final gender = widget.gender;
    final petType = widget.petType;
    final breed = widget.breed;


    await API.createPet(
        imageProfile: imageProfile,
        petName: petName,
        gender: gender,
        petType: petType,
        breed: breed,
        dateOfBirth : dateOfBirth,
        note: note,
        currentDiet: currentDiet,
        userId: userId,
        weight: double.tryParse(weight) ?? 0.0,

    );
    setState(() {
      isClicked =
          !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
    });
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => home(),
    ));

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
              builder: (context) => petprofile(),
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
                      text: '2',
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
                width: 284,
                height: 10,
                decoration: ShapeDecoration(
                  color: Color(0xFFFFBD58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                    'Birth Date',
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
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '',
                          filled: true,
                          fillColor: Color(0xFFD9D9D9),
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        readOnly: true, // Ngăn người dùng chỉnh sửa trường này
                        controller: TextEditingController(
                          // Hiển thị giá trị ngày tháng năm đã chọn (nếu có)
                          text: selectedDate != null
                              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                              : "",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'DOB is required';
                          }
                          // You can add additional email format validation here if needed
                          return null;
                        },
                        onTap: () {
                          _selectDate(
                              context); // Khi người dùng nhấp vào trường ngày tháng năm
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(
                            context); // Khi người dùng nhấp vào biểu tượng lịch
                      },
                    ),
                  ],
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
                    'Weight (kg)',
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
                height: 20,
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
                  controller: _weightController,
                  keyboardType: TextInputType.number, // Set the keyboard type to number
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Weight is required';
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
                    'Current Diet',
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
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isWetFoodSelected = true;
                        isDryFoodSelected = false;
                        isMixSelected = false;
                        _currentDietController.text = 'Wet Food'; // Set the controller's text
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.08,
                      color:
                      isWetFoodSelected ? Color(0xFFFFBD58) : Colors.grey,
                      child: Center(
                        child: Text(
                          'Wet Food',
                          style: TextStyle(
                            color:
                            isWetFoodSelected ? Colors.white : Colors.black,
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
                        isWetFoodSelected = false;
                        isDryFoodSelected = true;
                        isMixSelected = false;
                        _currentDietController.text = 'Dry Food'; // Set the controller's text
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.08,
                      color:
                      isDryFoodSelected ? Color(0xFFFFBD58) : Colors.grey,
                      child: Center(
                        child: Text(
                          'Dry Food',
                          style: TextStyle(
                            color:
                            isDryFoodSelected ? Colors.white : Colors.black,
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
                        isWetFoodSelected = false;
                        isDryFoodSelected = false;
                        isMixSelected = true;
                        _currentDietController.text = 'Mix'; // Set the controller's text
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.08,
                      color: isMixSelected ? Color(0xFFFFBD58) : Colors.grey,
                      child: Center(
                        child: Text(
                          'Mix',
                          style: TextStyle(
                            color: isMixSelected ? Colors.white : Colors.black,
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
                    'Pre-existing Conditions',
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
                height: 20,
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
                  controller: _noteController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pre-condition is required';
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
                    'Finish',
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
