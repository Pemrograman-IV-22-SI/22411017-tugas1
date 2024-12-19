import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:tugas_1_biodata/api_service/api.dart';
import 'package:tugas_1_biodata/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String routeName = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final dio = Dio();

  bool isLoading = false;

  TextEditingController fullnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              Image.asset(
                "assets/images/icon_movie.png",
                width: 200,
              ),
              const Text(
                "Register Akun",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: fullnameController,
                decoration: const InputDecoration(
                  labelText: "Fullname",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  labelText: "Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true),
              const SizedBox(height: 10),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (fullnameController.text.isEmpty &&
                            fullnameController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Fullname tidak boleh kosong"),
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored);
                        } else if (usernameController.text.isEmpty &&
                            usernameController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Username tidak boleh kosong"),
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored);
                        } else if (emailController.text.isEmpty &&
                            emailController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Email tidak boleh kosong"),
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored);
                        } else if (numberController.text.isEmpty &&
                            numberController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Number tidak boleh kosong"),
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored);
                        } else if (addressController.text.isEmpty &&
                            addressController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Address tidak boleh kosong"),
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored);
                        } else if (passwordController.text.isEmpty &&
                            passwordController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Password tidak boleh kosong"),
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored);
                        } else {
                          registerResponse();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Sudah Punya Akun?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPage.routeName);
                    },
                    child: const Text('Login Akun'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  void registerResponse() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));

      Response response;
      response = await dio.post(register, data: {
        "fullname": fullnameController.text,
        "username": usernameController.text,
        "email": emailController.text,
        "number": numberController.text,
        "address": addressController.text,
        "password": passwordController.text,
      });

      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, LoginPage.routeName);
      } else {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored);
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: const Text("Terjadi Kesalahan pada Kode"),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
