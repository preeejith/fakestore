import 'package:fakestore/bloc/mainbloc.dart';
import 'package:fakestore/ui/common/initializer.dart';
import 'package:fakestore/ui/common/materialbutton.dart';
import 'package:fakestore/ui/helper/helper.dart';
import 'package:fakestore/ui/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 226, 226),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 231, 226, 226),
        leading: const Icon(
          Icons.arrow_back_ios_new_sharp,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: BlocListener<MainBloc, MainState>(
            listenWhen: (previous, current) => current is SigninSuccess,
            listener: (context, state) {
              if (state is SigninSuccess) {
                Helper.push(context, const HomeScreen());
              }
            },
            child: _login(
              context,
            )),
      ),
    );
  }

  _login(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: Helper.width(context),
                color: Colors.white,
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/loginimg.png"),
                          radius: 55,
                          backgroundColor: Colors.grey,
                        ),
                        const Text(
                          "Log in ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff282828),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: Helper.height(context) / 85,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.grey.shade100,
                            child: TextFormField(
                              showCursor: true,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.black,
                              controller: Initializer.email,
                              validator: (value) {
                                RegExp emailRegExp = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                );
                                if (value == null) {
                                  return 'Please enter email';
                                } else if (!emailRegExp.hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(fontSize: 12),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                focusColor: Colors.black,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 9.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Password",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff282828),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Helper.height(context) / 85,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.grey.shade100,
                            child: TextFormField(
                              showCursor: true,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              obscureText:
                                  !isPasswordVisible, // Hide the password if isPasswordVisible is false
                              cursorColor: Colors.black,
                              controller: Initializer.password,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: const TextStyle(fontSize: 12),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ),
                                focusColor: Colors.black,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Helper.height(context) / 25,
                        ),
                        CommonButton(
                          width: Helper.width(context),
                          height: 48,
                          fun: () {
                            if (formKey.currentState!.validate()) {
                              if (Initializer.email.text != "" ||
                                  Initializer.password.text != "") {
                                BlocProvider.of<MainBloc>(context)
                                    .add(SignIn());
                              } else {
                                Helper.showToast(msg: "Please enter Password");
                              }
                            } else {}
                          },
                          text: "Log In",
                        ),
                        SizedBox(
                          height: Helper.height(context) / 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Do not have an account?",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600),
            ),
            InkWell(
              child: const Text(
                "  Sign Up",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Helper.push(context, const HomeScreen());
              },
            ),
          ],
        ),
      ],
    );
  }
}
