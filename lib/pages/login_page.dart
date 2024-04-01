import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:login_page/pages/signup_page.dart';
import '../JsonModels/users.dart';
import '../SQlite/sqlite.dart';
import 'Splash.dart';
import 'home.dart'; // Import the DatabaseHelper class

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffb4cdfa), Color(0xf49682de)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Image.asset('assets/images/robot.png'),
                  Text(
                    "Welcome Back!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const Text(
                    "Please , Log In.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (value){
                      if (value!.isEmpty){
                        return "Email is required";
                      }
                      return null;
                    },
                    controller: _emailController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Color(0xff3C3C43)),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
                      filled: true,
                      hintText: "Email",
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/icons/user_icon.svg"),
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(37),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (value){
                      if (value!.isEmpty){
                        return "Password is required";
                      }
                      return null;
                    },
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Color(0xff3C3C43)),
                    controller: _passwordController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
                      filled: true,
                      hintText: "Password",
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/icons/key_icon.svg"),
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(37),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xff78258B),
                        borderRadius: BorderRadius.circular(37),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if(formKey.currentState!.validate()){
                        // Perform authentication
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        bool isAuthenticated = await authenticateUser(email, password);

                        if (isAuthenticated) {
                          // Redirect to another page after successful authentication
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SplashScreen()),
                          );
                        } else {
                          // Handle authentication failure (show error message)
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Authentication Failed'),
                              content: Text('Invalid email or password. Please try again.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: 15,),
                  SvgPicture.asset('assets/icons/deisgn.svg'),
                  SizedBox(height: 15),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      decoration:  BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 45,
                            spreadRadius: 0,
                            color: Color.fromRGBO(120, 37, 139, 0.25),
                            offset: Offset(0, 25),
                          )
                        ],
                        borderRadius: BorderRadius.circular(37),
                        color: const Color.fromRGBO(225, 225, 225, 0.28),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Authentication function
  Future<bool> authenticateUser(String email, String password) async {
    // Replace this with your actual authentication logic
    // Check if the user exists in the database
    User? user = await DatabaseHelper().getUser(email);

    if (user != null && user.userPassword == password) {
      return true; // Authentication successful
    } else {
      return false; // Authentication failed
    }
  }
}
