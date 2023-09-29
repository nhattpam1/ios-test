import 'package:flutter/material.dart';
import 'package:petcare/main.dart';
import 'package:petcare/otp.dart';
import 'package:http/http.dart' as http;
import 'package:petcare/api-petcare/api.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;
  bool isLoading = false; // Add isLoading state variable
  List<String> genders = ['Male', 'Female'];
  String? selectedGender;
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

  //register form get data
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();


  //register function
  Future<void> _registerUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final fullName = _fullNameController.text;
    final address = _addressController.text;
    final gender = selectedGender ?? ""; // Handle this better if needed
    final phone = _phonecontroller.text;

    // Map gender to 1 for Male and 0 for Female
    bool genderValue = selectedGender == 'Male' ? true : false;
    final dateOfBirth =
    selectedDate != null ? selectedDate!.toIso8601String() : "";

    setState(() {
      isLoading = true;
    });

    // Call the registerUser function from the API class
    await API.registerUser(
      email: email,
      password: password,
      fullName: fullName,
      address: address,
      gender: genderValue,
      dateOfBirth: dateOfBirth,
      phone : phone,
      authCodeCallback: (authCode) {
        // Set the authCode value
        otp.authCode = authCode;

        // Handle navigation to the otp page
        setState(() {
          isLoading = false; // Set isLoading to false when sign-up is complete
        });
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => otp(email: email),
        ));
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF9F1EF),
          title: Text(
            'Sign Up',
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
                isClicked =
                !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
              });
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
            },
          ),
        ),
        backgroundColor: Color(0xFFF9F1EF),
        body: SingleChildScrollView(
          child: Center(
              child: Form(
                key: _formKey, // Assign the form key
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
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
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@')) {
                            return 'Email must contain the @ symbol';
                          }
                          // You can add additional email format validation here if needed
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        obscureText: true, // To hide the password input
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          // You can add additional email format validation here if needed
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        obscureText: true, // To hide the password input
                        decoration: InputDecoration(
                          labelText: 'Password Comfirm',
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
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password confirm is required';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          // You can add additional email format validation here if needed
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Full Name',
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
                        controller: _fullNameController,
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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Address',
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
                        controller: _addressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Address is required';
                          }
                          // You can add additional email format validation here if needed
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          filled: true,
                          fillColor: Color(0xFFD9D9D9),
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        hint: Text('Select Gender'),
                        value: selectedGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                        items: genders.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        dropdownColor: Color(0xFFD9D9D9),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Gender is required';
                          }
                          return null;
                        },
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
                                labelText: 'Date of Birth',
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
                              readOnly:
                              true, // Ngăn người dùng chỉnh sửa trường này
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
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone',
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
                        controller: _phonecontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone is required';
                          }
                          // Check if the value starts with '0' and contains exactly 10 digits
                          if (!RegExp(r'^0[0-9]{9}$').hasMatch(value)) {
                            return 'Phone must start with 0 and be a 10-digit number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: isLoading // Disable button while loading
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          await _registerUser();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                        isLoading ? Colors.grey : Color(0xFFFFBD58), // Disable button color
                      ),
                      child: isLoading // Show loading indicator or text
                          ? CircularProgressIndicator()
                          : Text(
                        'Sign Up',
                        style: TextStyle(
                          color: isLoading ? Colors.white : Colors.black,
                          fontSize: 25,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Forgot your password?',
                      style: TextStyle(
                        color: Color(0xFFB12A1C),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              )),
        ));
  }
}