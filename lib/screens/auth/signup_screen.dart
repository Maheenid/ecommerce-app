import 'dart:io';
import 'package:ecommerce_app/screens/auth/login_screen.dart';
import 'package:ecommerce_app/screens/bottom_navigaion_screen.dart';
import 'package:ecommerce_app/services/upload_user_information_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool isloading = false;
  final _firebase = FirebaseAuth.instance;
  String? email;
  String? password;
  File? selectedImage;
  String? userImageUrl;

  pickCameraImage() async {
    final cameraImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (cameraImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(cameraImage.path);
    });
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  pickGalleryImage() async {
    final cameraImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (cameraImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(cameraImage.path);
    });
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  removeImage() async {
    setState(() {
      selectedImage = null;
    });
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actions: [
                          Center(
                            child: TextButton(
                              onPressed: pickCameraImage,
                              child: const Text(
                                'Camera',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: pickGalleryImage,
                              child: const Text(
                                'Gallery',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: removeImage,
                              child: const Text(
                                'remove',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: selectedImage != null
                        ? FileImage(selectedImage!)
                        : const AssetImage('assets/noperson.jpg')
                            as ImageProvider,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: const OutlineInputBorder(),
                        fillColor: Colors.grey.shade200,
                      ),
                      keyboardType: TextInputType.name,
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please add a valid username';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: const OutlineInputBorder(),
                        fillColor: Colors.grey.shade200,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value.toString();
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'please add a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Passowrd',
                        border: const OutlineInputBorder(),
                        fillColor: Colors.grey.shade200,
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        password = value.toString();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please add a valid password';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 70,
              width: 350,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 22, 22, 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 110, vertical: 20),
                ),
                onPressed: () async {
                  final isValid = _formkey.currentState!.validate();
                  if (selectedImage == null) {
                    showDialog(
                      context: context,
                      builder: (ctx) => const AlertDialog(
                        title: Text('please add image'),
                      ),
                    );
                    return;
                  }
                  if (isValid) {
                    setState(() {
                      isloading = true;
                    });
                    try {
                      await _firebase.createUserWithEmailAndPassword(
                        email: email!,
                        password: password!,
                      );
                    } on FirebaseAuthException catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    }

                    final User? user = FirebaseAuth.instance.currentUser;
                    if (user == null && context.mounted) {
                      return;
                    }

                    final String uid = user!.uid;
                    final ref = FirebaseStorage.instance
                        .ref()
                        .child('usersImages')
                        .child('$uid.jpg');
                    await ref.putFile(
                      File(selectedImage!.path),
                    );
                    userImageUrl = await ref.getDownloadURL();

                    await UploadUserInformation().uploadData(
                      user: uid,
                      userName: _usernameController.text,
                      userEmail: email,
                      userImage: userImageUrl,
                      userCart: [],
                      userFavorite: [],
                      userOrder: [],
                    );
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const BottomNavigationScreen(),
                        ),
                      );
                    }
                  }
                  setState(() {
                    isloading = false;
                  });
                },
                child: const Text(
                  'SignUp',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
