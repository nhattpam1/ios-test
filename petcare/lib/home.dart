import 'package:flutter/material.dart';
import 'package:petcare/model-petcare/pet.dart';
import 'package:petcare/model-petcare/product.dart';
import 'package:petcare/model-petcare/service.dart';
import 'package:petcare/shop.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:petcare/session-petcare/session.dart';
import 'package:petcare/api-petcare/api.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;
  int _currentIndex = 0;
  final List<Widget> _screens = [];
  List<Container> petContainersList = [];
  late List<Product> products = [];
  late List<Service> services = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    //list products
    loadProducts();
    loadServices();

    //try to get userId in session
    int? userId = SessionManager().userId;

    if (userId != null) {
      // You have the userId, you can use it here
      print('User ID trong session home: $userId');

      //try print list pets by userId
      fetchPetData(userId);
    } else {
      // User is not logged in or userId is not set
      print('User ID trong session home: $userId');
    }
  }

  Container buildPetContainer(Pet pet) {
    final now = DateTime.now();

    DateTime? dateOfBirth;

    if (pet.dateOfBirth != null) {
      dateOfBirth = DateTime.tryParse(pet.dateOfBirth!);
    }

    final ageDifference = now.year - dateOfBirth!.year;

    return Container(
      width: 397.39,
      height: 213,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 400,
              height: 300,
              decoration: ShapeDecoration(
                color: Color(0xFFFFBD58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "${pet.petName ?? ''}'s Summary",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                )),
          ),
          Align(
            alignment: Alignment.topLeft, // Căn lề dưới và trái
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Row(
                children: [
                  Text(
                    "Type:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4), // Khoảng cách giữa "Type:" và "Cat"
                  Text(
                    pet.petType ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft, // Căn lề dưới và trái
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
              child: Row(
                children: [
                  Text(
                    "Breed:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4), // Khoảng cách giữa "Type:" và "Cat"
                  Text(
                    pet.breed ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft, // Căn lề dưới và trái
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
              child: Row(
                children: [
                  Text(
                    "Gender:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4), // Khoảng cách giữa "Type:" và "Cat"
                  Text(
                    pet.gender == true ? "Male" : "Female",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft, // Căn lề dưới và trái
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
              child: Row(
                children: [
                  Text(
                    "Age:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4), // Khoảng cách giữa "Type:" và "Cat"
                  Text(
                    "$ageDifference yrs old" ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10), // Căn chỉnh theo nhu cầu của bạn
              child: Container(
                width: 100,
                height: 100,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      pet.imageProfile ?? 'https://via.placeholder.com/116x119',
                    ),
                    fit: BoxFit.fill,
                  ),
                  shape: OvalBorder(),
                  shadows: [
                    BoxShadow(
                      color: Color(0x26646464),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20), // Căn chỉnh theo nhu cầu của bạn
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 60),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isClicked =
                              !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => home(),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            isClicked ? Colors.black : Color(0xFF8A3030),
                      ),
                      child: Text(
                        'Data Insights',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //function get pets by userId
  Future<void> fetchPetData(int userId) async {
    List<Pet> pets = await API.getPetsByUserId(userId);

    List<Container> petContainers = pets.map((pet) {
      return buildPetContainer(pet);
    }).toList();

    setState(() {
      // Set the list of pet containers in your state
      petContainersList = petContainers;
    });
  }

  //function get products
  void loadProducts() async {
    List<Product> loadedProducts = await API.getProducts();
    setState(() {
      products = loadedProducts;
    });
  }

  //function get services
  void loadServices() async {
    List<Service> loadedServices = await API.getServices();

    for (Service v in loadedServices) {
      print(v.serviceName);
    }
    setState(() {
      services = loadedServices;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.width * 0.1,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFFBD58),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isClicked =
                                    !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => home(),
                              ));
                            },
                            icon: Icon(
                              Icons.menu,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ), // Adjust the spacing
                  Text(
                    'Home',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  Container(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.width * 0.1,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFFBD58),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isClicked =
                                    !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => home(),
                              ));
                            },
                            icon: Icon(
                              Icons.shopping_bag,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Khoảng cách giữa biểu tượng và văn bản "Home"
                ],
              ),
              SizedBox(
                height: 30,
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 220, // Chiều cao của slide
                  enlargeCenterPage: true,
                  autoPlay: false,
                  enableInfiniteScroll: false,
                ),
                items: petContainersList,
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0), // Điều chỉnh giá trị left tùy ý
                  child: Row(
                    children: [
                      Text(
                        'Reminders',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      SizedBox(width: 4), // Khoảng cách giữa "Type:" và "Cat"
                      Text(
                        '(2)',
                        style: TextStyle(
                          color: Color(0xFFB12A1C),
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 362.03,
                height: 87.84,
                decoration: ShapeDecoration(
                  color: Color(0xFFEFEFEF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Text(
                          'Vet Appointment Due',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft, // Căn lề dưới và trái
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 40),
                        child: Row(
                          children: [
                            Text(
                              "It has been",
                              style: TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0.16,
                              ),
                            ),
                            SizedBox(
                                width: 4), // Khoảng cách giữa "Type:" và "Cat"
                            Text(
                              "354",
                              style: TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                height: 0.16,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              ' days since your last vet visit. ',
                              style: TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0.16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft, // Căn lề dưới và trái
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 30),
                        child: Row(
                          children: [
                            Text(
                              "Book your annual vet appointment with us now!",
                              style: TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0.16,
                              ),
                            ),
                            SizedBox(width: 4),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0), // Căn chỉnh theo nhu cầu của bạn
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 10),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isClicked =
                                        !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
                                  });
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => home(),
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: isClicked
                                      ? Colors.black
                                      : Color(0xFFB12A1C),
                                ),
                                child: Text(
                                  'Book',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 362.03,
                height: 87.84,
                decoration: ShapeDecoration(
                  color: Color(0xFFEFEFEF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Text(
                          'Food Supply Low  ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft, // Căn lề dưới và trái
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 40),
                        child: Row(
                          children: [
                            Text(
                              "It has been",
                              style: TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0.16,
                              ),
                            ),
                            SizedBox(
                                width: 4), // Khoảng cách giữa "Type:" và "Cat"
                            Text(
                              "40",
                              style: TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                height: 0.16,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              ' days since your last cat food purchase ',
                              style: TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0.16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft, // Căn lề dưới và trái
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 30),
                        child: Row(
                          children: [
                            Text(
                              "with us. Restock your food supply now!",
                              style: TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0.16,
                              ),
                            ),
                            SizedBox(width: 4),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0), // Căn chỉnh theo nhu cầu của bạn
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 10),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isClicked =
                                        !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
                                  });
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => shop(),
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: isClicked
                                      ? Colors.black
                                      : Color(0xFFB12A1C),
                                ),
                                child: Text(
                                  'Shop',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                  child: Row(
                    children: [
                      Text(
                        'Recommended Products',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      SizedBox(width: 40), // Khoảng cách giữa "Type:" và "Cat"
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => shop()),
                          );
                        },
                        child: Text(
                          'See All',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF979797),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0), // Điều chỉnh giá trị left tùy ý
                  child: Row(
                    children: [
                      Text(
                        'Based on previous purchases and similar pet owners',
                        style: TextStyle(
                          color: Color(0xFF979797),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 350,
                  enlargeCenterPage: true,
                  autoPlay: true,
                ),
                items: products.map((product) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              product.image ?? '',
                              width: 200,
                              height: 200,
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 80), // Điều chỉnh giá trị left tùy ý
                                child: Row(
                                  children: [
                                    Text(
                                      product.brand ?? '',
                                      style: TextStyle(
                                        color: Color(0xFF979797),
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            50), // Khoảng cách giữa "Type:" và "Cat"
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                    Text(
                                      '4.9',
                                      style: TextStyle(
                                        color: Color(0xFFABABAB),
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 60),
                                child: Row(
                                  children: [
                                    Text(
                                      product.productName ?? '',
                                      style: TextStyle(
                                        color: Color(0xFF3F434A),
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0.14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 60),
                                child: Row(
                                  children: [
                                    Text(
                                      "\$${product.price != null ? product.price!.toStringAsFixed(2) : 'N/A'}",
                                      style: TextStyle(
                                        color: Color(0xFFB12A1C),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0), // Điều chỉnh giá trị left tùy ý
                  child: Row(
                    children: [
                      Text(
                        'Recommended Services',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      SizedBox(width: 40), // Khoảng cách giữa "Type:" và "Cat"
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => shop(
                                  initialTabIndex: 1), // Set initialTabIndex
                            ),
                          );
                        },
                        child: Text(
                          'See All',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF979797),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0), // Điều chỉnh giá trị left tùy ý
                  child: Row(
                    children: [
                      Text(
                        'Based on previously booked services',
                        style: TextStyle(
                          color: Color(0xFF979797),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 350,
                  enlargeCenterPage: true,
                  autoPlay: true,
                ),
                items: services.map((service) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              service.image ?? '',
                              width: 200,
                              height: 200,
                            ),
                            SizedBox(height: 5),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 60),
                                child: Row(
                                  children: [
                                    Text(
                                      service.serviceName ?? '',
                                      style: TextStyle(
                                        color: Color(0xFF3F434A),
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0.14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 60),
                                child: Row(
                                  children: [
                                    Text(
                                      "\$${service.price != null ? service.price!.toStringAsFixed(2) : 'N/A'}",
                                      style: TextStyle(
                                        color: Color(0xFFB12A1C),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(
                height: 30,
              ),
              IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Add conditions for other tabs if needed.
          // Add conditions for other tabs if needed.
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => shop()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.red : Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              color: _currentIndex == 1 ? Colors.red : Colors.black,
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bar_chart,
              color: _currentIndex == 2 ? Colors.red : Colors.black,
            ),
            label: 'Insight',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 3 ? Colors.red : Colors.black,
            ),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.red, // Màu của label khi được chọn
        unselectedItemColor: Colors.black, // Màu của label khi không được chọn
        selectedLabelStyle: TextStyle(color: Colors.black), // Màu của chữ label
        unselectedLabelStyle: TextStyle(color: Colors.red),
      ),
    );
  }
}
